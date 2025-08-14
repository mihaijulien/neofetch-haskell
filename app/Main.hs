module Main (main) where

import Info (getMem, showMemMB, getCurrentUser, getSystemName, getCPUInfo, getUptime, getOSversion, getGpuInfo)
import Data.Maybe (fromMaybe)

main :: IO ()
main = do
  currentUser <- getCurrentUser
  systenName <- getSystemName
  putStrLn $ fromMaybe "unknwon" currentUser ++ "@" ++ fromMaybe "unknown" systenName
  putStrLn "-----------------"
  os <- getOSversion
  putStrLn $ "OS: " ++ fromMaybe "Unknown" os
  uptime <- getUptime
  putStrLn $ "Uptime: " ++ uptime
  cpu <- getCPUInfo
  putStrLn $ "CPU: " ++ fromMaybe "Unknown" cpu
  gpu <- getGpuInfo
  putStrLn $ "GPU: " ++ fromMaybe "Unknwon" gpu
  memory <- getMem
  case memory of
    Just memKb -> putStrLn $ "Memory (total): " ++ show (showMemMB memKb) ++ " MB"
    Nothing    -> putStrLn $ "Could not retrieve memory info"