{-# LANGUAGE Safe #-}

-- A lightweight, portable implementation of a Vector-like API backed by lists.
-- This avoids using GHC primitives so it can be compiled easily inside a
-- container for testing.

module Data.Vector.Simple (
  Vector,
  empty,
  singleton,
  fromList,
  replicate,
  length,
  null,
  (!),
  head,
  last,
  cons,
  snoc,
  (++),
  take,
  drop,
  map,
  filter,
  toList
) where

import Prelude hiding (length, null, head, last, map, filter, take, drop, replicate, (++))
import qualified Prelude as P
import qualified Data.List as L

newtype Vector a = V { unV :: [a] }

empty :: Vector a
empty = V []

singleton :: a -> Vector a
singleton x = V [x]

fromList :: [a] -> Vector a
fromList xs = V xs

replicate :: Int -> a -> Vector a
replicate n x = V (L.replicate n x)

length :: Vector a -> Int
length (V xs) = L.length xs

null :: Vector a -> Bool
null (V xs) = L.null xs

(!) :: Vector a -> Int -> a
(V xs) ! i
  | i < 0 || i >= L.length xs = error "Índice fora dos limites"
  | otherwise = xs L.!! i

head :: Vector a -> a
head (V xs) = case xs of
  (y:_) -> y
  [] -> error "head: empty Vector"

last :: Vector a -> a
last (V xs) = case L.reverse xs of
  (y:_) -> y
  [] -> error "last: empty Vector"

cons :: a -> Vector a -> Vector a
cons x (V xs) = V (x:xs)

snoc :: Vector a -> a -> Vector a
snoc (V xs) x = V ((P.++) xs [x])

(++) :: Vector a -> Vector a -> Vector a
(V a) ++ (V b) = V ((P.++) a b)

take :: Int -> Vector a -> Vector a
take n (V xs) = V (L.take n xs)

drop :: Int -> Vector a -> Vector a
drop n (V xs) = V (L.drop n xs)

map :: (a -> b) -> Vector a -> Vector b
map f (V xs) = V (L.map f xs)

filter :: (a -> Bool) -> Vector a -> Vector a
filter p (V xs) = V (L.filter p xs)

toList :: Vector a -> [a]
toList (V xs) = xs
