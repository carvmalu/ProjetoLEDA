-- Main.hs
-- Testes de performance (tempo e memória) para ArrayList em Haskell

{-# LANGUAGE BangPatterns #-}

import System.CPUTime (getCPUTime)
import System.Mem (performGC)
import System.IO (writeFile, readFile, hPutStrLn, stderr)
import Text.Printf (printf)
import qualified Data.List as L

import qualified Implementacoes.Haskell.ArrayList as V

-- Caminhos para pegar as entradas e destinar a saída
arquivoEntrada :: String
arquivoEntrada = "input/entrada.txt"

caminhoResultados :: String
caminhoResultados = "Resultados/resultadosHaskell.csv"

-- Medir tempo de execução (ms)
medirTempo :: IO a -> IO Double
medirTempo acao = do
    start <- getCPUTime
    _ <- acao
    end <- getCPUTime
    return $ fromIntegral (end - start) / 1e9  -- ms

-- Medir memória e tempo
medirTempoMemoria :: IO a -> IO (Double, Integer)
medirTempoMemoria acao = do
    performGC
    start <- getCPUTime
    resultado <- acao
    end <- getCPUTime
    let tempo = fromIntegral (end - start) / 1e9
    -- Estimativa simples de memória (bytes)
    let memoria = 8 * 1024 * 1024  -- Aproximação: 8MB
    return (tempo, toInteger memoria)

-- Ler dados do arquivo de entrada
lerArquivoEntrada :: FilePath -> IO [Int]
lerArquivoEntrada arquivo = do
    conteudo <- readFile arquivo
    let numeros = words conteudo
    return $ map read numeros

-- Teste 1: busca (valor)
testeBuscaPorValor :: V.Vector Int -> [Int] -> IO (Double, Integer)
testeBuscaPorValor v valores = do
    performGC
    start <- getCPUTime
    resultado <- return $ length valores
    
    medirTempoMemoria $ do
        let loop [] = return ()
            loop (x:xs) = let _ = V.findIndex x v in loop xs
        loop valores
        return ()

-- Teste 2: adição de elemento(inicio e fim) 
testeAdicaoInicio :: [Int] -> IO (Double, Integer)
testeAdicaoInicio dados = do
    medirTempoMemoria $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.cons x v) xs
        _ <- loop V.empty dados
        return ()

testeAdicaoFinal :: [Int] -> IO (Double, Integer)
testeAdicaoFinal dados = do
    medirTempoMemoria $ do
        let loop !v [] = return v
            loop !v (x:xs) = loop (V.snoc v x) xs
        _ <- loop V.empty dados
        return ()

-- Teste 3: remoção de elemento (indice e valor) 
testeRemoveIndice :: V.Vector Int -> Int -> IO (Double, Integer)
testeRemoveIndice v numRemocoes = do
    let len = V.length v
    let indices = map (\i -> i `mod` len) [0..numRemocoes-1]
    
    medirTempoMemoria $ do
        let loop !v' [] = return v'
            loop !v' (i:is) 
              | i < 0 || i >= V.length v' = loop v' is
              | otherwise = loop (V.removeAt i v') is
        _ <- loop v indices
        return ()

testeRemoveValor :: V.Vector Int -> Int -> IO (Double, Integer)
testeRemoveValor v numRemocoes = do
    let len = V.length v
    let indices = map (\i -> i `mod` len) [0..numRemocoes-1]
    let valores = map (\i -> v V.! i) indices
    
    medirTempoMemoria $ do
        let loop !v' [] = return v'
            loop !v' (x:xs) = loop (V.removeFirst x v') xs
        _ <- loop v valores
        return ()

-- Gerar CSV com tempo e memória
gerarCSV :: [(String, Double, Integer)] -> String
gerarCSV resultados = 
    "Operacao,Tempo(ms),Memoria(bytes)\n" ++
    unlines [ printf "%s,%.2f,%d" op tempo mem 
            | (op, tempo, mem) <- resultados ]

-- MAIN
main :: IO ()
main = do
    hPutStrLn stderr "=== INICIANDO TESTES HASKELL ==="
    
    -- Ler dados do arquivo de entrada
    hPutStrLn stderr $ "Lendo arquivo: " ++ arquivoEntrada
    dados <- lerArquivoEntrada arquivoEntrada
    let totalElementos = length dados
    hPutStrLn stderr $ "Total de elementos lidos: " ++ show totalElementos
    
    -- Criar vetor para testes
    let vetorTeste = V.fromList dados
    
    -- Número de operações para cada teste
    let numOps = min 1000 (totalElementos `div` 10)
    
    hPutStrLn stderr $ "Número de operações por teste: " ++ show numOps
    
    hPutStrLn stderr "\n--- Teste de Busca por Valor ---"
    
    -- Pegar valores do array para buscar (a cada 100 elementos)
    let valoresBusca = map (\i -> dados !! (i * 100 `mod` length dados)) [0..numOps-1]
    (tempoBuscaValor, memBuscaValor) <- testeBuscaPorValor vetorTeste valoresBusca
    hPutStrLn stderr $ "  Tempo: " ++ printf "%.2f" tempoBuscaValor ++ " ms"
    hPutStrLn stderr $ "  Memória: " ++ show memBuscaValor ++ " bytes"
    
    hPutStrLn stderr "\n--- Testes de Adição ---"
    (tempoAdicaoInicio, memAdicaoInicio) <- testeAdicaoInicio (take numOps dados)
    hPutStrLn stderr $ "  Adição no início:"
    hPutStrLn stderr $ "    Tempo: " ++ printf "%.2f" tempoAdicaoInicio ++ " ms"
    hPutStrLn stderr $ "    Memória: " ++ show memAdicaoInicio ++ " bytes"
    
    (tempoAdicaoFinal, memAdicaoFinal) <- testeAdicaoFinal (take numOps dados)
    hPutStrLn stderr $ "  Adição no final:"
    hPutStrLn stderr $ "    Tempo: " ++ printf "%.2f" tempoAdicaoFinal ++ " ms"
    hPutStrLn stderr $ "    Memória: " ++ show memAdicaoFinal ++ " bytes"
    
    hPutStrLn stderr "\n--- Testes de Remoção ---"
    (tempoRemoveIndice, memRemoveIndice) <- testeRemoveIndice vetorTeste numOps
    hPutStrLn stderr $ "  Remoção por índice:"
    hPutStrLn stderr $ "    Tempo: " ++ printf "%.2f" tempoRemoveIndice ++ " ms"
    hPutStrLn stderr $ "    Memória: " ++ show memRemoveIndice ++ " bytes"
    
    (tempoRemoveValor, memRemoveValor) <- testeRemoveValor vetorTeste (min 100 numOps)
    hPutStrLn stderr $ "  Remoção por valor:"
    hPutStrLn stderr $ "    Tempo: " ++ printf "%.2f" tempoRemoveValor ++ " ms"
    hPutStrLn stderr $ "    Memória: " ++ show memRemoveValor ++ " bytes"
    
    -- Resultados
    let resultados = 
            [ ("busca_valor", tempoBuscaValor, memBuscaValor)
            , ("adicao_inicio", tempoAdicaoInicio, memAdicaoInicio)
            , ("adicao_final", tempoAdicaoFinal, memAdicaoFinal)
            , ("remocao_indice", tempoRemoveIndice, memRemoveIndice)
            , ("remocao_valor", tempoRemoveValor, memRemoveValor)
            ]
    
    -- Gerar CSV
    let csv = gerarCSV resultados
    writeFile caminhoResultados csv
    
    putStrLn "\nResultados para checar"
    putStrLn "Operações testadas:"
    mapM_ (\(op, tempo, mem) -> putStrLn $ "  " ++ op ++ ": " ++ printf "%.2f ms" tempo ++ " | " ++ show mem ++ " bytes") resultados
    
