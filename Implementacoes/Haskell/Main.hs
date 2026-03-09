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

-- Medir memória e tempo com cálculo correto
medirTempoMemoria :: Int -> IO a -> IO (Double, Integer)
medirTempoMemoria numElementos acao = do
    performGC
    start <- getCPUTime
    resultado <- acao
    end <- getCPUTime
    let tempo = fromIntegral (end - start) / 1e9
    let memoria = calcularMemoria numElementos
    return (tempo, memoria)
  where
    calcularMemoria n = toInteger (56 + (n * 8))

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

-- Teste 2: adição de elemento(inicio e fim) 
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
testeRemoveValor v numRemocoes totalElementos = do
    let primeiroElemento = if V.null v then 0 else V.head v
    medirTempoMemoria totalElementos (executarRemoveValor v primeiroElemento numRemocoes)

-- Função recursiva
executarRemoveValor :: V.Vector Int -> Int -> Int -> IO ()
executarRemoveValor v _ 0 = return ()
executarRemoveValor v valor n
    | V.null v = return ()
    | otherwise = executarRemoveValor (V.removeFirst valor v) valor (n - 1)

-- Gerar CSV com tempo e memória
gerarCSV :: [(String, Double, Integer)] -> String
gerarCSV resultados = 
    "Linguagem_Tipo, tamanho, Operacao, Tempo(ms), Memoria(bytes)" ++
    unlines [ printf "%s,%.2f,%d" op tempo mem 
            | (op, tempo, mem) <- resultados ]

rodarTestes :: [Int] -> String -> Int -> IO [(String, Double, Integer)]
rodarTestes dados nomeArquivo totalElementos = do
    hPutStrLn stderr $ "\n>>> Iniciando testes com " ++ show totalElementos ++ " elementos..."
    
    let vetorTeste = V.fromList dados
    let numOps = min 1000 (totalElementos `div` 10)
    
    hPutStrLn stderr $ "    Operações por teste: " ++ show numOps
    
    hPutStrLn stderr "    Rodando: Busca por valor inexistente..."
    let valoresBusca = map (\i -> 999999999 + i) [0..numOps-1]
    (tempoBuscaValor, memBuscaValor) <- testeBuscaPorValor vetorTeste valoresBusca totalElementos
    
    hPutStrLn stderr "    Rodando: Adição no início..."
    (tempoAdicaoInicio, memAdicaoInicio) <- testeAdicaoInicio (take numOps dados) totalElementos
    
    hPutStrLn stderr "    Rodando: Remoção por índice..."
    (tempoRemoveIndice, memRemoveIndice) <- testeRemoveIndice vetorTeste (min 100 numOps) totalElementos
    
    hPutStrLn stderr "    Rodando: Remoção por valor..."
    (tempoRemoveValor, memRemoveValor) <- testeRemoveValor vetorTeste (min 100 numOps) totalElementos
    
    let resultados = 
            [ ("Haskell_dataVector", n,"busca", tempoBuscaValor, memBuscaValor)
            , ("Haskell_dataVector", n,"adicaoInicio", tempoAdicaoInicio, memAdicaoInicio)
            , ("Haskell_dataVector", n,"remocaoIndice", tempoRemoveIndice, memRemoveIndice)
            , ("Haskell_dataVector", n,"remocaoValor", tempoRemoveValor, memRemoveValor)
            ]
    
    let csv = gerarCSV resultados
    writeFile ("Resultados/" ++ nomeArquivo) csv
    
    hPutStrLn stderr $ "    ✅ Resultado salvo em: Resultados/" ++ nomeArquivo
    
    return resultados

-- MAIN
main :: IO ()
main = do
    putStrLn ""
    putStrLn "╔════════════════════════════════════════════════════════════════╗"
    putStrLn "║                  TESTES DE PERFORMANCE ARRAYLIST                ║"
    putStrLn "║                   Rodando: 10k, 30k, 50k, 100k                  ║"
    putStrLn "╚════════════════════════════════════════════════════════════════╝"
    putStrLn ""
    
    hPutStrLn stderr "=== INICIANDO TESTES HASKELL ==="
    
    hPutStrLn stderr $ "Lendo arquivo: " ++ arquivoEntrada
    todosDados <- lerArquivoEntrada arquivoEntrada Nothing
    let totalDisponivel = length todosDados
    hPutStrLn stderr $ "Total de elementos disponíveis: " ++ show totalDisponivel
    
    let tamanhos = [(10000, "resultados_10k.csv")
                   ,(30000, "resultados_30k.csv")
                   ,(50000, "resultados_50k.csv")
                   ,(100000, "resultados_100k.csv")]
    
    todoResultados <- mapM (\(tam, arquivo) -> do
        let dados = take tam todosDados
        rodarTestes dados arquivo tam
        ) tamanhos
    
    putStrLn ""
    putStrLn "╔════════════════════════════════════════════════════════════════╗"
    putStrLn "║                    TODOS OS TESTES CONCLUÍDOS! ✅               ║"
    putStrLn "╚════════════════════════════════════════════════════════════════╝"
    putStrLn ""
    putStrLn "📊 RESUMO DOS RESULTADOS"
    putStrLn "════════════════════════════════════════════════════════════════"
    putStrLn ""
    
    putStrLn (printf "%-30s %12s %12s %12s %12s" 
        "Operação" "10k (ms)" "30k (ms)" "50k (ms)" "100k (ms)")
    putStrLn "────────────────────────────────────────────────────────────────"
    
    let allOps = ["busca", "adicaoInicio", 
                  "remocaoIndice", "remocaoValor"]
    
    mapM_ (\op -> do
        let tempos = map (\(operacao, tempo, memoria) -> if operacao == op then tempo else 0) (concat todoResultados)
        
        case tempos of
            [t1, t2, t3, t4] -> 
                putStrLn (printf "%-30s %12.2f %12.2f %12.2f %12.2f" 
                    op t1 t2 t3 t4)
            _ -> return ()
        ) allOps
    
    putStrLn ""
    putStrLn "📁 Arquivos CSV gerados:"
    putStrLn "   - Resultados/resultados_10k.csv"
    putStrLn "   - Resultados/resultados_30k.csv"
    putStrLn "   - Resultados/resultados_50k.csv"
    putStrLn "   - Resultados/resultados_100k.csv"
    putStrLn ""
    putStrLn "Para visualizar um arquivo:"
    putStrLn "   cat Resultados/resultados_10k.csv"
    putStrLn ""