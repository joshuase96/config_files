-- IMPORTS
import XMonad
import XMonad.Config.Desktop
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig(additionalKeys)
import Data.Monoid
import System.Exit

import qualified XMonad.StackSet  as W
import qualified Data.Map         as M

-- VARS
myModMask = mod1Mask
myBorderW = 0
myWorkSpaces = ["1", "2", "3", "4", "5"]

myTerm    = "kitty"
myBrowser = "firefox"
myFileManager = "pcmanfm"
myAppLauncher = "rofi -show run"

myStartupHook = do
  spawnOnce "nitrogen --restore" 

-- KEYBINDS
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
  [ ((modm .|. shiftMask, xK_Return), spawn myTerm)
  , ((modm              , xK_w),      spawn myBrowser)
  , ((modm              , xK_f),      spawn myFileManager)
  , ((modm              , xK_p),      spawn myAppLauncher)
  , ((modm .|. shiftMask, xK_q),      kill)
  , ((modm              , xK_q),      spawn "xmonad --recompile; xmonad --restart")
  ]
  ++
  [((m .|. modm, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-- MAIN
main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ desktopConfig
    {
      terminal      = myTerm,
      borderWidth   = myBorderW,
      modMask       = myModMask,
      workspaces    = myWorkSpaces,
      keys          = myKeys,
      startupHook   = myStartupHook
    }
