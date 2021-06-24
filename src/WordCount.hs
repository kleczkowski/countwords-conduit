module WordCount where

import Conduit
import qualified Data.Conduit.Combinators as C

import Control.Monad
import Data.ByteString (ByteString)
import qualified Data.ByteString as BS
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Text (Text)
import qualified Data.Text as Text
import qualified Data.Text.Encoding as Text
import Data.Char (isLetter)

-- | Counts words in text file that contains short lines.
wordCount :: ( MonadIO m
             , MonadThrow m
             )
          => ConduitT () ByteString m ()  -- ^ Source conduit that provides chunked data.
          -> m (Map Text Int)             -- ^ Words summary wrapped around a monad.
wordCount src
  = runConduit
   $ src
  .| C.splitOnUnboundedE (== 32)
  .| C.filter (not . BS.null)
  .| C.map ( (`Map.singleton` 1)
           . Text.filter isLetter
           . Text.decodeUtf8
           )
  .| C.foldl (Map.unionWith (+)) Map.empty

-- | Pretty-prints word summary.
showStatistics :: Map Text Int -> IO ()
showStatistics stats = do
  forM_ (Map.toAscList stats) $ \(w, c) -> do
    putStr (Text.unpack w)
    putStr "\t\t"
    print c

-- | Entry point of the program.
main :: IO ()
main = wordCount C.stdin >>= showStatistics
