import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

myModMask = mod4Mask
myTerminal = "st"
myBorderWidth = 2
myNormalBorderColor = "#698CEC"
myFocusedBorderColor = "#9974E7"
myMouseFocusRule = False

myManageHook = composeAll
  [ className =? "Firefox" --> doShift "3"
  , className =? "Firefox" --> doFloat
  , className =? "Tor Browser" --> doShift "4"
  , className =? "Tor Browser" --> doFloat
  , className =? "KeePassXC" --> doShift "5"
  , className =? "mpv" --> doShift "9"
  , manageDocks ]

myLayoutHook = avoidStruts
  $ spacingRaw False (Border 20 0 20 0) True (Border 0 20 0 20) True
  $ Tall 1 (3/100) (1/2) ||| Full

main = do
  xmonad $ docks def
    { layoutHook        = myLayoutHook
    , borderWidth       = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor= myFocusedBorderColor
    , modMask           = myModMask
    , terminal          = myTerminal
    , focusFollowsMouse = myMouseFocusRule
    , manageHook        = myManageHook <+> manageHook def }
