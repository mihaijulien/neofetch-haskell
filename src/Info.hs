module Info
  ( getMem
  ) where

import Control.Exception (catch, IOException)
import System.Directory (doesFileExist)
import Data.List (isPrefixOf)

readFileSafe :: FilePath -> IO (Maybe String)
readFileSafe p = do
  exists <- doesFileExist p
  if not exists
    then return Nothing
    else readFileWithCatch p
        where
          readFileWithCatch :: FilePath -> IO (Maybe String)
          readFileWithCatch filePath = (Just <$> readFile filePath) `catch` handleReadError
          
          handleReadError :: IOException -> IO (Maybe String)
          handleReadError _ = return Nothing

getMem :: IO (Maybe Integer)
getMem = do
  m <- readFileSafe "/proc/meminfo"
  return $ do
    content <- m
    let ls = lines content
    memLine <- case filter ("MemTotal:" `isPrefixOf`) ls of
                 (x:_) -> Just x
                 _     -> Nothing
    let toks = words memLine
    case toks of
      (_:val:_) -> case reads val of
                     [(n, _)] -> Just n
                     _        -> Nothing
      _         -> Nothing