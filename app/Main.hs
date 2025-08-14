module Main (main) where

import Data.Maybe (fromMaybe)
import Info
  ( getMem
  , showMemMB
  , getCurrentUser
  , getSystemName
  , getCPUInfo
  , getUptime
  , getOSversion
  , getGpuInfo
  )

-- https://stackoverflow.com/questions/21220142/change-color-of-a-string-haskell

main :: IO ()
main = do
  currentUser <- getCurrentUser
  systenName <- getSystemName
  putStrLn $ "\ESC[31m" ++ fromMaybe "unknwon" currentUser ++ "\ESC[37m@\ESC[31m" ++ fromMaybe "unknown" systenName
  putStrLn "-----------------"
  os <- getOSversion
  putStrLn $ "\ESC[31mOS\ESC[37m: " ++ fromMaybe "Unknown" os
  uptime <- getUptime
  putStrLn $ "\ESC[31mUptime\ESC[37m: " ++ uptime
  cpu <- getCPUInfo
  putStrLn $ "\ESC[31mCPU\ESC[37m: " ++ fromMaybe "Unknown" cpu
  gpu <- getGpuInfo
  putStrLn $ "\ESC[31mGPU\ESC[37m: " ++ fromMaybe "Unknwon" gpu
  memory <- getMem
  case memory of
    Just memKb -> putStrLn $ "\ESC[31mMemory (total)\ESC[37m: " ++ show (showMemMB memKb) ++ " MB"
    Nothing    -> putStrLn $ "Could not retrieve memory info"