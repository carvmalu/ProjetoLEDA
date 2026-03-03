{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UnboxedTuples #-}

module Data.Vector.Simple (
  -- * Vetores (imutáveis para comparação)
  Vector,
  
  -- * Operações básicas -como ArrayList
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
  (++),  -- concatenação
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
  
  -- ** Conversão
  toList
) where

import GHC.Exts
import qualified Data.List as L

-- | Estrutura simples: offset + length + array primitivo
data Vector a = V {-# UNPACK #-} !Int  -- offset
                   {-# UNPACK #-} !Int  -- length
                   (Array a)            -- dados reais

-- | Vetor vazio
empty :: Vector a
empty = V 0 0 (emptyArray#)

-- | Vetor com um elemento
singleton :: a -> Vector a
singleton x = fromList [x]

-- | Criar vetor a partir de lista
fromList :: [a] -> Vector a
fromList xs = let arr = listArray# xs
              in V 0 (L.length xs) arr

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
  | i < 0 || i >= len = error "Índice fora dos limites"
  | otherwise = case indexArray# arr (off + i) of
                  (# x #) -> x

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
-- Exemplo: removeAt 2 <1,2,3,4,5> = <1,2,4,5>
removeAt :: Int -> Vector a -> Vector a
removeAt i v
  | i < 0 || i >= length v = error "removeAt: índice fora dos limites"
  | otherwise = fromList (L.take i (toList v) ++ L.drop (i+1) (toList v))

-- | Remover primeira ocorrência de um valor (cria novo vetor)
-- Exemplo: removeFirst 3 <1,3,2,3,4> = <1,2,3,4>
removeFirst :: Eq a => a -> Vector a -> Vector a
removeFirst x v = fromList $ go (toList v)
  where
    go [] = []
    go (y:ys)
      | x == y    = ys
      | otherwise = y : go ys

-- | Remover todas as ocorrências de um valor (cria novo vetor)
-- Exemplo: removeAll 3 <1,3,2,3,4> = <1,2,4>
removeAll :: Eq a => a -> Vector a -> Vector a
removeAll x v = filter (/= x) v

-- | Adicionar elemento no início (cria novo vetor)
cons :: a -> Vector a -> Vector a
cons x v = fromList (x : toList v)

-- | Adicionar elemento no final (cria novo vetor)
snoc :: Vector a -> a -> Vector a
snoc v x = fromList (toList v ++ [x])

-- | Concatenação de vetores (cria novo vetor)
(++) :: Vector a -> Vector a -> Vector a
v1 ++ v2 = fromList (toList v1 ++ toList v2)

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

-- | Converter para lista (útil para debug/comparação)
toList :: Vector a -> [a]
toList (V off len arr) = go 0
  where
    go i | i >= len  = []
         | otherwise = case indexArray# arr (off + i) of
                         (# x #) -> x : go (i+1)

-- Funções auxiliares para arrays primitivos
foreign import primitive "ghc-prim_emptyArray#"
  emptyArray# :: Array a

foreign import primitive "ghc-prim_newArray#"
  newArray# :: Int -> a -> State# RealWorld -> (# State# RealWorld, Array a #)

foreign import primitive "ghc-prim_indexArray#"
  indexArray# :: Array a -> Int -> (# a #)

foreign import primitive "ghc-prim_writeArray#"
  writeArray# :: Array a -> Int -> a -> State# RealWorld -> State# RealWorld

-- | Criar array a partir de lista (simplificado)
listArray# :: [a] -> Array a
listArray# xs = runRW# $ \s0 ->
  case newArray# (L.length xs) (error "uninitialized") s0 of
    (# s1, arr #) -> let loop s _ [] = (# s, arr #)
                          loop s i (x:xs) = 
                            case writeArray# arr i x s of
                              s' -> loop s' (i+1) xs
                     in loop s1 0 xs