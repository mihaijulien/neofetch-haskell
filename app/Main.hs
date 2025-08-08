module Main (main) where

import Info (getMem)

main :: IO ()
main = do
  memory <- getMem
  case memory of
    Just mem -> putStrLn $ "Memory (total): " ++ show mem
    Nothing  -> putStrLn $ "Could not retrieve memory info"