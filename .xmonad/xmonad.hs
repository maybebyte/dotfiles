import XMonad
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageDocks
import System.IO
import XMonad.Hooks.EwmhDesktops

myModMask            = mod4Mask
myTerminal           = "st"
myBorderWidth        = 0
myMouseFocusRule     = False

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
  xmonad
    $ ewmh
    $ docks def
    { handleEventHook    = fullscreenEventHook
    , layoutHook         = myLayoutHook
    , borderWidth        = myBorderWidth
    , modMask            = myModMask
    , terminal           = myTerminal
    , focusFollowsMouse  = myMouseFocusRule
    , manageHook         = myManageHook <+> manageHook def }
