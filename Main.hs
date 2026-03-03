module Main where

import qualified Data.Vector.Simple as V

main :: IO ()
main = print (V.toList (V.fromList [1,2,3] :: V.Vector Int))
