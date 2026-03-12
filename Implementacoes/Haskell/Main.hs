-- Main.hs
-- Testes de performance (tempo e memória) para ArrayList em Haskell

{-# LANGUAGE BangPatterns #-}

import System.CPUTime (getCPUTime)
import System.Mem (performGC)
import System.IO (writeFile, readFile, hPutStrLn, stderr, openFile, IOMode(WriteMode), hFlush, hClose)
import Text.Printf (printf)
import System.Environment (getArgs)
import qualified Data.List as L
import Control.Monad
import qualified Implementacoes.Haskell.ArrayList as V
import GHC.Conc (getAllocationCounter, setAllocationCounter)

-- Caminhos para pegar as entradas e destinar a saída
arquivoEntrada :: String
arquivoEntrada = "input/entrada.txt"

caminhoResultados :: String
caminhoResultados = "Resultados/resultadosHaskell.csv"

-- Medir memória e tempo
medirTempoMemoria :: Int -> IO a -> IO (Double, Integer)
medirTempoMemoria numElementos acao = do
    performGC
    setAllocationCounter 0
    start <- getCPUTime
    resultado <- acao
    end <- getCPUTime
    memoriaUsada <- getAllocationCounter
    let tempo = fromIntegral (end - start) / 1e9
    return (tempo, toInteger (abs memoriaUsada))

-- Ler dados do arquivo de entrada
lerArquivoEntrada :: FilePath -> Maybe Int -> IO [Int]
lerArquivoEntrada arquivo maximo = do
    conteudo <- readFile arquivo
    let numeros = map read (words conteudo)
    case maximo of
        Nothing -> return numeros
        Just n -> return $ take n numeros

-- Teste 1: busca (valor)
testeBuscaPorValor :: V.Vector Int -> [Int] -> Int -> IO (Double, Integer)
testeBuscaPorValor v valores totalElementos = 
   medirTempoMemoria totalElementos (executarBuscas v valores)

-- Função recursiva para executar buscas
executarBuscas :: V.Vector Int -> [Int] -> IO ()
executarBuscas v [] = return ()
executarBuscas v (x:xs) = do
    let _ = V.findIndex x v
    executarBuscas v xs

-- Teste 2: adição de elemento
testeAdicaoInicio :: [Int] -> Int -> IO (Double, Integer)
testeAdicaoInicio dados totalElementos = 
    medirTempoMemoria totalElementos $ do
        let loop !v [] = 
                let len = V.length v
                in len `seq` return v
            loop !v (x:xs) = loop (V.cons x v) xs
        _ <- loop V.empty dados
        return ()

-- Teste 3: remoção de elemento (indice e valor) 
testeRemoveIndice :: V.Vector Int -> Int -> Int -> IO (Double, Integer)
testeRemoveIndice v numRemocoes totalElementos = 
    medirTempoMemoria totalElementos (executarRemoveIndice v numRemocoes)

-- Função recursiva que remove sempre o PRIMEIRO elemento (índice 0)
-- Pior caso: O(n) por remoção, total O(n²)
executarRemoveIndice :: V.Vector Int -> Int -> IO ()
executarRemoveIndice v 0 = return ()
executarRemoveIndice v n
    | V.null v = return ()
    | otherwise = executarRemoveIndice (V.removeAt 0 v) (n - 1)

testeRemoveValor :: V.Vector Int -> Int -> Int -> IO (Double, Integer)
testeRemoveValor v numRemocoes totalElementos = 
    medirTempoMemoria totalElementos (executarRemoveValor v primeiroElemento numRemocoes)
  where
    primeiroElemento = if V.null v then 0 else V.head v

-- Função recursiva
executarRemoveValor :: V.Vector Int -> Int -> Int -> IO ()
executarRemoveValor v _ 0 = return ()
executarRemoveValor v valor n
    | V.null v = return ()
    | otherwise = executarRemoveValor (V.removeFirst valor v) valor (n - 1)

-- Gerar CSV com tempo e memória
gerarCSV :: Int -> [(String, String, String, Double, Integer)] -> String
gerarCSV totalElementos resultados = 
    "Linguagem_Tipo,Tamanho,Operacao,Tempo(ms),Memoria(bytes)\n" ++
    unlines [ printf "Haskell_dataVector,%d,%s,%.2f,%s" totalElementos op tempo (show mem)
            | (_, _, op, tempo, mem) <- resultados ]

rodarTestes :: [Int] -> String -> Int -> IO [(String, String, String, Double, Integer)]
rodarTestes dados nomeArquivo totalElementos = do
    hPutStrLn stderr $ "\n>>> Iniciando testes com " ++ show totalElementos ++ " elementos..."

    let vetorTeste = V.fromList dados
    let numOps = min 1000 (totalElementos `div` 10)
    
    hPutStrLn stderr $ "    Operações por teste: " ++ show numOps
    
    hPutStrLn stderr "    Rodando: Busca por valor 7..."
    let valoresBusca = replicate numOps 7
    (tempoBuscaValor, memBuscaValor) <- testeBuscaPorValor vetorTeste valoresBusca totalElementos
    
    hPutStrLn stderr "    Rodando: Adição no início..."
    (tempoAdicaoInicio, memAdicaoInicio) <- testeAdicaoInicio (take numOps dados) totalElementos
    
    hPutStrLn stderr "    Rodando: Remoção por índice..."
    (tempoRemoveIndice, memRemoveIndice) <- testeRemoveIndice vetorTeste (min 100 numOps) totalElementos
    
    hPutStrLn stderr "    Rodando: Remoção por valor..."
    (tempoRemoveValor, memRemoveValor) <- testeRemoveValor vetorTeste (min 100 numOps) totalElementos
    
    let resultados = 
            [ ("Haskell_dataVector", show totalElementos, "busca", tempoBuscaValor, memBuscaValor)
            , ("Haskell_dataVector", show totalElementos, "adicaoInicio", tempoAdicaoInicio, memAdicaoInicio)
            , ("Haskell_dataVector", show totalElementos, "remocaoIndice", tempoRemoveIndice, memRemoveIndice)
            , ("Haskell_dataVector", show totalElementos, "remocaoValor", tempoRemoveValor, memRemoveValor)
            ]
    
    let csv = gerarCSV totalElementos resultados
    writeFile ("Resultados/Haskell/" ++ nomeArquivo) csv
    
    return resultados

-- MAIN
main :: IO ()
main = do
    args <- getArgs
    
    if null args
        then do
            putStrLn "Uso: ./main_haskell <tamanho1> <tamanho2> ... <numVezes>"
            putStrLn "Exemplo: ./main_haskell 10000 30000 50000 100000 10"
        else do
            let tamanhos = map read (init args) :: [Int]
            let numVezes = read (last args) :: Int
            
            -- Abrir arquivo de log
            logHandle <- openFile "saida.log" WriteMode
            
            hPutStrLn logHandle "Iniciando testes"
            hPutStrLn logHandle $ "Lendo arquivo: " ++ arquivoEntrada
            hFlush logHandle
            
            todosDados <- lerArquivoEntrada arquivoEntrada Nothing
            let totalDisponivel = length todosDados
            hPutStrLn logHandle $ "Total de elementos disponíveis: " ++ show totalDisponivel
            hFlush logHandle
            
            resultadosAcumulados <- forM [1..numVezes] $ \i -> do
                hPutStrLn logHandle $ "Execução " ++ show i ++ " de " ++ show numVezes ++ "..."
                hFlush logHandle
                mapM (\tam -> do
                    let arquivo = "resultados_" ++ show tam ++ "k.csv"
                    let dados = take tam todosDados
                    rodarTestes dados arquivo tam
                    ) tamanhos

            let todasAsSomas = concat (concat resultadosAcumulados)
            let operacoes = ["busca", "adicaoInicio", "remocaoIndice", "remocaoValor"]

            hPutStrLn logHandle "Calculando médias..."
            hFlush logHandle
            
            mapM_ (\tam -> do
                let nomeArquivoMedia = "media_" ++ show tam ++ "k.csv"
                let resultadosPorTamanho = [r | rs <- resultadosAcumulados, r <- rs, let (_, _, _, _, _) = r, 
                                            let (_, _, _, _, _) = r]
                
                let csv = "Linguagem_Tipo,Tamanho,Operacao,Tempo_Media(ms),Memoria(bytes)\n" ++
                          unlines [printf "Haskell_dataVector,%d,%s,%.2f,%s" tam op 
                                   (somarTemposComTam tam op (concat resultadosAcumulados) / fromIntegral numVezes)
                                   (show (somarMemoriaComTam tam op (concat resultadosAcumulados) `div` fromIntegral numVezes))
                                  | op <- operacoes]
                
                writeFile ("Resultados/Haskell/" ++ nomeArquivoMedia) csv
                ) tamanhosa
                hFlush logHandle
                ) tamanhos
            
            hPutStrLn logHandle "Testes finalizados"
            hClose logHandle
    
somarTemposComTam :: Int -> String -> [(String, String, String, Double, Integer)] -> Double
somarTemposComTam tam op resultados = 
    sum [tempo | (_, _, operacao, tempo, _) <- resultados, operacao == op, 
         read (show tam) == tam]

somarMemoriaComTam :: Int -> String -> [(String, String, String, Double, Integer)] -> Integer
somarMemoriaComTam tam op resultados = 
    sum [mem | (_, _, operacao, _, mem) <- resultados, operacao == op,
         read (show tam) == tam]
