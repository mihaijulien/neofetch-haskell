module Main (main) where

import Info (getMem, showMemMB, getCurrentUser, getSystemName)
import Data.Maybe (fromMaybe)

main :: IO ()
main = do
  currentUser <- getCurrentUser
  systenName <- getSystemName
  putStrLn $ fromMaybe "unknwon" currentUser ++ "@" ++ fromMaybe "unknown" systenName
  memory <- getMem
  case memory of
    Just memKb -> putStrLn $ "Memory (total): " ++ show (showMemMB memKb) ++ " MB"
    Nothing    -> putStrLn $ "Could not retrieve memory info"