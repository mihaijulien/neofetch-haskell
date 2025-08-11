module Info
  ( getMem
  , showMemMB
  , getCurrentUser
  , getSystemName
  , getCPUInfo
  , getUptime
  , getOSversion
  ) where

import Control.Exception (catch, IOException)
import System.Directory (doesFileExist)
import Data.List (isPrefixOf)
import System.Process

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

showMemMB :: Integer -> Integer
showMemMB kb = kb `div` 1024

getCurrentUser :: IO (Maybe String)
getCurrentUser = do
  user <- readProcess "whoami" [] []
  return $ if null user then Nothing else Just (init user) -- init removes the newline char

getSystemName :: IO (Maybe String)
getSystemName = do
  hostname <- readProcess "hostname" [] []
  return $ if null hostname then Nothing else Just hostname

getCPUInfo :: IO (Maybe String)
getCPUInfo = do
  cpu <- readFileSafe "/proc/cpuinfo"
  return $ do
    content <- cpu
    let ls = lines content
        model = [ drop (length "model name\t: ") l | l <- ls, "model name" `isPrefixOf` l]
    case model of
      (x:_) -> Just x
      _     -> Nothing

getUptime :: IO (String)
getUptime = readProcess "uptime" ["-p"] []

getOSversion :: IO (Maybe String)
getOSversion = do
    os <- readFileSafe "/etc/os-release"
    return $ do
      content <- os
      let ls = lines content
          pretty = [ drop (length "PRETTY_NAME=") l | l <- ls, "PRETTY_NAME=" `isPrefixOf` l ]
          trimQuotes ('"':rest) | last rest == '"' = init rest
          trimQuotes s = s
      case pretty of
        (x:_) -> Just (trimQuotes x)
        _     -> Nothing
