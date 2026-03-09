{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE TypeFamilies #-}

module Implementacoes.Haskell.ArrayList (
  -- * Vetores (imutáveis para comparação)
  Vector(..),
  
  -- * Operações básicas - como ArrayList
  -- ** Criação
  empty,
  singleton,
  fromList,
  replicate,
  
  -- ** Acesso
  length,
  null,
  (!),
  head,
  last,
  
  -- ** cria novos vetores
  cons,  -- adicionar no início
  snoc,  -- adicionar no final
  append, -- concatenação (sem conflito com (++))
  take,
  drop,
  
  -- ** remoção de vetores
  removeAt,    -- remover elemento em índice específico
  removeFirst, -- remover primeira ocorrência de um valor
  removeAll,   -- remover todas as ocorrências de um valor
  tail,        -- remover primeiro elemento
  init,        -- remover último elemento
  
  -- ** Transformação
  map,
  filter,
  
  -- ** Busca
  findIndex,      -- encontrar primeira ocorrência
  memberOf,     -- verificar se contém valor

  -- ** Conversão
  toList

) where

-- Import do Prelude ESCONDENDO APENAS as funções que vamos redefinir
-- NÃO ocultamos (++) porque precisamos dele para concatenar strings!
import Prelude hiding (length, null, filter, tail, init, map, head, last, take, drop, replicate)

import qualified Data.List as L
import qualified Data.Primitive.Array as Prim
import Control.Monad.ST (runST)

-- | Estrutura simples: offset + length + array primitivo
data Vector a = V {-# UNPACK #-} !Int  -- offset
                   {-# UNPACK #-} !Int  -- length
                   !(Prim.Array a)      -- dados reais

-- | Vetor vazio
empty :: Vector a
empty = V 0 0 Prim.emptyArray

-- | Vetor com um elemento
singleton :: a -> Vector a
singleton x = fromList [x]

-- | Criar vetor a partir de lista
fromList :: [a] -> Vector a
fromList xs = V 0 (L.length xs) (listArray xs)

-- | Criar array a partir de lista (usando primitive)
listArray :: [a] -> Prim.Array a
listArray xs = runST $ do
    let len = L.length xs
    marr <- Prim.newArray len (error "listArray: elemento não inicializado")
    let loop i [] = return ()
        loop i (x:xs) = do
            Prim.writeArray marr i x
            loop (i+1) xs
    loop 0 xs
    Prim.unsafeFreezeArray marr

-- | Vetor com n cópias do mesmo valor
replicate :: Int -> a -> Vector a
replicate n x = fromList (L.replicate n x)

-- | Tamanho do vetor
length :: Vector a -> Int
length (V _ n _) = n

-- | Vetor vazio?
null :: Vector a -> Bool
null v = length v == 0

-- | Acesso por índice O(1) (como ArrayList)
(!) :: Vector a -> Int -> a
(!) (V off len arr) i
  | i < 0 || i >= len = error ("Índice fora dos limites: " ++ show i ++ " (tamanho: " ++ show len ++ ")")
  | otherwise = Prim.indexArray arr (off + i)

-- | Primeiro elemento
head :: Vector a -> a
head v = v ! 0

-- | Último elemento
last :: Vector a -> a
last v = v ! (length v - 1)

-- | Remover primeiro elemento (cria novo vetor)
tail :: Vector a -> Vector a
tail v
  | null v   = error "tail: vetor vazio"
  | otherwise = fromList (L.tail (toList v))

-- | Remover último elemento (cria novo vetor)
init :: Vector a -> Vector a
init v
  | null v   = error "init: vetor vazio"
  | otherwise = fromList (L.init (toList v))

-- | Remover elemento em índice específico (cria novo vetor)
removeAt :: Int -> Vector a -> Vector a
removeAt i v
  | i < 0 || i >= length v = error ("removeAt: índice " ++ show i ++ " fora dos limites (tamanho: " ++ show (length v) ++ ")")
  | otherwise = fromList (L.take i (toList v) L.++ L.drop (i+1) (toList v))

-- | Remover primeira ocorrência de um valor (cria novo vetor)
removeFirst :: Eq a => a -> Vector a -> Vector a
removeFirst x v = fromList $ go (toList v)
  where
    go [] = []
    go (y:ys)
      | x == y    = ys
      | otherwise = y : go ys

-- | Remover todas as ocorrências de um valor (cria novo vetor)
removeAll :: Eq a => a -> Vector a -> Vector a
removeAll x v = filter (/= x) v

-- | Adicionar elemento no início (cria novo vetor)
cons :: a -> Vector a -> Vector a
cons x v = fromList (x : toList v)

-- | Adicionar elemento no final (cria novo vetor)
snoc :: Vector a -> a -> Vector a
snoc v x = fromList (toList v L.++ [x])

-- | Concatenação de vetores (cria novo vetor)
append :: Vector a -> Vector a -> Vector a
append v1 v2 = fromList (toList v1 L.++ toList v2)

-- | Primeiros n elementos
take :: Int -> Vector a -> Vector a
take n v = fromList (L.take n (toList v))

-- | Remover primeiros n elementos
drop :: Int -> Vector a -> Vector a
drop n v = fromList (L.drop n (toList v))

-- | Mapear função sobre todos elementos
map :: (a -> b) -> Vector a -> Vector b
map f v = fromList (L.map f (toList v))

-- | Filtrar elementos
filter :: (a -> Bool) -> Vector a -> Vector a
filter p v = fromList (L.filter p (toList v))

-- | Encontrar índice da primeira ocorrência de um valor (-1 se não encontrado)
findIndex :: Eq a => a -> Vector a -> Int
findIndex x v = go 0
  where
    len = length v
    go i | i >= len  = -1
         | otherwise = if v ! i == x then i else go (i + 1)

-- | Verificar se o vetor contém um valor
memberOf :: Eq a => a -> Vector a -> Bool
memberOf x v = findIndex x v /= -1

-- | Converter para lista (útil para debug/comparação)
toList :: Vector a -> [a]
toList (V off len arr) = go 0
  where
    go i | i >= len  = []
         | otherwise = Prim.indexArray arr (off + i) : go (i+1)

