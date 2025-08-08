module Main (main) where

import Info (getMem, showMemMB)

main :: IO ()
main = do
  memory <- getMem
  case memory of
    Just memKb -> putStrLn $ "Memory (total): " ++ show (showMemMB memKb) ++ " MB"
    Nothing    -> putStrLn $ "Could not retrieve memory info"