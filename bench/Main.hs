module Main (main) where

import WordCount hiding (main)
import Criterion.Main
import qualified Data.Conduit.Combinators as C

main :: IO ()
main = defaultMain
  [ bench "wordCount/pan-tadeusz"     $ nfIO (C.withSourceFile "pan-tadeusz.txt"     wordCount)
  , bench "wordCount/kjvbible"        $ nfIO (C.withSourceFile "kjvbible.txt"        wordCount)
  ]
