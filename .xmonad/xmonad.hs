import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myModMask = mod4Mask
myTerminal = "st"
myBorderWidth = 0

myManageHook = composeAll
  [ className =? "Firefox" --> doShift "3:ff"
  , className =? "Firefox" --> doFloat
  , className =? "Tor Browser" --> doShift "4:tb"
  , className =? "Tor Browser" --> doFloat
  , className =? "mpv" --> doShift "9:mpv"
  , manageDocks ]


myWorkSpaces = ["1:dev","2","3:ff","4:tb","5:pw","6","7","8","9:mpv"]

main = do
  xmonad $ docks def
    { layoutHook        = avoidStruts $ layoutHook def
    , borderWidth       = myBorderWidth
    , workspaces        = myWorkSpaces
    , modMask           = myModMask
    , terminal          = myTerminal
    , focusFollowsMouse = False
    , manageHook        = myManageHook <+> manageHook def }
