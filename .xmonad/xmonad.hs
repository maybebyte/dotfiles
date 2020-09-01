import XMonad
import XMonad.Layout.Spacing
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
  , className =? "KeePassXC" --> doShift "5:pw"
  , className =? "mpv" --> doShift "9:mpv"
  , manageDocks ]

myLayoutHook = avoidStruts
  $ spacingRaw False (Border 20 0 20 0) True (Border 0 20 0 20) True
  $ Tall 1 (3/100) (1/2) ||| Full

myWorkSpaces = ["1:dev","2","3:ff","4:tb","5:pw","6","7","8","9:mpv"]

main = do
  xmonad $ docks def
    { layoutHook        = myLayoutHook
    , borderWidth       = myBorderWidth
    , workspaces        = myWorkSpaces
    , modMask           = myModMask
    , terminal          = myTerminal
    , focusFollowsMouse = False
    , manageHook        = myManageHook <+> manageHook def }
