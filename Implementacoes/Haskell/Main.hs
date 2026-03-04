-- Main.hs
-- Programa para testar 100.000 entradas com Vector Simple
-- Saída: CSV com tempo, memória e segurança
-- /https://blog.formacao.dev/manipulacao-de-arquivos-csv-em-java-leitura-e-escrita/

{-# LANGUAGE BangPatterns #-}

import System.CPUTime (getCPUTime)
import System.Mem (performGC)
import System.Environment (getArgs)
import System.IO (writeFile, readFile, hPutStrLn, stderr)
import qualified Data.Vector.Simple as V
import qualified Data.List as L
import Control.Exception (evaluate, try, SomeException)
import Control.DeepSeq (NFData(..), deepseq)
import Text.Printf (printf)
import System.Random (randomRIO, mkStdGen, randomRs)
import System.Random.Stateful (randomRIO)

-- Constantes
totalEntradas :: Int
totalEntradas = 100000

caminhoResultados :: String
caminhoResultados = "../../Resultados/Haskell/resultadosHaskell.csv"

-- Medir tempo de execução (ms)
medirTempo :: IO a -> IO Double
medirTempo acao = do
    start <- getCPUTime
    _ <- acao
    end <- getCPUTime
    return $ fromIntegral (end - start) / 1e9  -- ms

-- Medir uso de memória aproximado (bytes)
medirMemoria :: IO a -> IO (Integer, a)
medirMemoria acao = do
    performGC
    -- Estimativa simples: cada Int em unboxed = 8 bytes
    -- Para vetores: cabeçalho + dados
    resultado <- acao
    resultado `deepseq` return ()
    return (estimativaMemoria resultado, resultado)
  where
    estimativaMemoria :: a -> Integer
    estimativaMemoria v = case v of
        (V.Vector _ len _) -> 24 + fromIntegral len * 8  -- cabeçalho + dados
        (_ :: [Int]) -> 16 + fromIntegral (L.length v) * 16  -- lista cons cells
        _ -> 0

-- Testar segurança de acesso
testarSeguranca :: IO [String]
testarSeguranca = do
    let vazio = V.empty :: V.Vector Int
        v = V.fromList [1..10]
    
    -- Teste Acesso dentro dos limites
    acessoValido <- try $ evaluate (v V.! 5) :: IO (Either SomeException Int)
    
    -- Teste Acesso fora dos limites com !
    acessoInvalido <- try $ evaluate (v V.! 100) :: IO (Either SomeException Int)
    
    -- Teste Acesso com !? (versão segura)
    let acessoMaybe = v V.!? 100
    
    -- Teste head em vetor vazio
    headVazio <- try $ evaluate (V.head vazio) :: IO (Either SomeException Int)
    
    -- Teste headMaybe (versão segura)
    let headMaybeVazio = V.headMaybe vazio
    
    return
        [ show (case acessoValido of Left _ -> 0; Right _ -> 1)
        , show (case acessoInvalido of Left _ -> 1; Right _ -> 0)
        , show (case acessoMaybe of Just _ -> 1; Nothing -> 0)
        , show (case headVazio of Left _ -> 1; Right _ -> 0)
        , show (case headMaybeVazio of Just _ -> 0; Nothing -> 1)
        ]

-- Vamos gerar dados aleatórios para teste
gerarDadosTeste :: Int -> IO [Int]
gerarDadosTeste n = do
    gen <- getStdGen
    return $ take n (randomRs (1, 10000) gen)

-- Teste Adição no início (cons)
testeCons :: [Int] -> IO (Double, Integer)
testeCons dados = do
    (memoria, _) <- medirMemoria $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.cons x v) xs
        _ <- loop V.empty dados
        return ()
    tempo <- medirTempo $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.cons x v) xs
        _ <- loop V.empty dados
        return ()
    return (tempo, memoria)

--Teste Adição no final (snoc)
testeSnoc :: [Int] -> IO (Double, Integer)
testeSnoc dados = do
    (memoria, _) <- medirMemoria $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.snoc v x) xs
        _ <- loop V.empty dados
        return ()
    tempo <- medirTempo $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.snoc v x) xs
        _ <- loop V.empty dados
        return ()
    return (tempo, memoria)

-- Teste Acesso aleatório
testeAcesso :: V.Vector Int -> Int -> IO (Double, Integer)
testeAcesso v numAcessos = do
    let len = V.length v
    indices <- replicateM numAcessos $ randomRIO (0, len - 1)
    
    (memoria, _) <- medirMemoria $ do
        let loop [] = return ()
            loop (i:is) = let _ = v V.! i in loop is
        loop indices
        return ()
    
    tempo <- medirTempo $ do
        let loop [] = return ()
            loop (i:is) = let _ = v V.! i in loop is
        loop indices
        return ()
    
    return (tempo, memoria)

-- Teste Remoção no início
testeRemocaoInicio :: V.Vector Int -> Int -> IO (Double, Integer)
testeRemocaoInicio v numRemocoes = do
    (memoria, _) <- medirMemoria $ do
        let loop !v' 0 = return v'
            loop !v' n = loop (V.tail v') (n - 1)
        _ <- loop v numRemocoes
        return ()
    
    tempo <- medirTempo $ do
        let loop !v' 0 = return v'
            loop !v' n = loop (V.tail v') (n - 1)
        _ <- loop v numRemocoes
        return ()
    
    return (tempo, memoria)

-- Teste Remoção no final
testeRemocaoFinal :: V.Vector Int -> Int -> IO (Double, Integer)
testeRemocaoFinal v numRemocoes = do
    (memoria, _) <- medirMemoria $ do
        let loop !v' 0 = return v'
            loop !v' n = loop (V.init v') (n - 1)
        _ <- loop v numRemocoes
        return ()
    
    tempo <- medirTempo $ do
        let loop !v' 0 = return v'
            loop !v' n = loop (V.init v') (n - 1)
        _ <- loop v numRemocoes
        return ()
    
    return (tempo, memoria)

-- Teste Remoção no meio
testeRemocaoMeio :: V.Vector Int -> Int -> IO (Double, Integer)
testeRemocaoMeio v numRemocoes = do
    let len = V.length v
    indices <- replicateM numRemocoes $ randomRIO (1, len - 2)
    
    (memoria, _) <- medirMemoria $ do
        let loop !v' [] = return v'
            loop !v' (i:is) = loop (V.removeAt i v') is
        _ <- loop v indices
        return ()
    
    tempo <- medirTempo $ do
        let loop !v' [] = return v'
            loop !v' (i:is) = loop (V.removeAt i v') is
        _ <- loop v indices
        return ()
    
    return (tempo, memoria)

-- Agora vamos gerar relatório CSV completo
gerarCSV :: [(String, Double, Integer, String)] -> String
gerarCSV resultados = 
    "Operacao,Tempo(ms),Memoria(bytes),Seguranca\n" ++
    unlines [ printf "%s,%.2f,%d,%s" op tempo mem seg 
            | (op, tempo, mem, seg) <- resultados ]

-- Main

main :: IO ()
main = do
    hPutStrLn stderr "=== INICIANDO TESTES COM 100.000 ENTRADAS ==="
    
    -- Gerar dados de teste
    hPutStrLn stderr "Gerando dados aleatórios..."
    dados <- gerarDadosTeste totalEntradas
    let vetorTeste = V.fromList dados
    
    -- Testes de segurança
    hPutStrLn stderr "Executando testes de segurança..."
    seguranca <- testarSeguranca
    
    -- Teste Cons (adição início)
    hPutStrLn stderr "Testando cons (adição início)..."
    (tempoCons, memCons) <- testeCons dados
    
    -- Teste Snoc (adição final)
    hPutStrLn stderr "Testando snoc (adição final)..."
    (tempoSnoc, memSnoc) <- testeSnoc dados
    
    -- Teste Acesso aleatório (1000 acessos)
    hPutStrLn stderr "Testando acesso aleatório..."
    (tempoAcesso, memAcesso) <- testeAcesso vetorTeste 1000
    
    -- Teste Remoção início (1000 remoções)
    hPutStrLn stderr "Testando remoção início..."
    (tempoRemInicio, memRemInicio) <- testeRemocaoInicio vetorTeste 1000
    
    -- Teste Remoção final (1000 remoções)
    hPutStrLn stderr "Testando remoção final..."
    (tempoRemFinal, memRemFinal) <- testeRemocaoFinal vetorTeste 1000
    
    -- Teste Remoção meio (100 remoções)
    hPutStrLn stderr "Testando remoção no meio..."
    (tempoRemMeio, memRemMeio) <- testeRemocaoMeio vetorTeste 100
    
    -- Compilar resultados
    let resultados = 
            [ ("cons", tempoCons, memCons, "OK")
            , ("snoc", tempoSnoc, memSnoc, "OK")
            , ("acesso", tempoAcesso, memAcesso, head seguranca)
            , ("remocao_inicio", tempoRemInicio, memRemInicio, "OK")
            , ("remocao_final", tempoRemFinal, memRemFinal, "OK")
            , ("remocao_meio", tempoRemMeio, memRemMeio, "OK")
            , ("seguranca_acesso", 0, 0, unwords seguranca)
            ]
    
    -- Gerar CSV
    let csv = gerarCSV resultados
    writeFile caminhoResultados csv
    
    -- Mostrar resultados na tela (apenas números para seu programa)
    putStrLn "=== RESULTADOS ==="
    putStrLn "Tempos (ms):"
    mapM_ (putStrLn . printf "%.2f") [tempoCons, tempoSnoc, tempoAcesso, 
                                       tempoRemInicio, tempoRemFinal, tempoRemMeio]
    
    putStrLn "\nMemória (bytes):"
    mapM_ (putStrLn . show) [memCons, memSnoc, memAcesso, 
                             memRemInicio, memRemFinal, memRemMeio]
    
    putStrLn "\nSegurança (1=seguro, 0=inseguro):"
    mapM_ putStrLn seguranca
    
    hPutStrLn stderr $ "\n✅ Resultados salvos em: " ++ caminhoResultados
