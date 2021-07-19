import System.IO
import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Spacing

myBorderWidth        = 0
myModMask            = mod4Mask
myMouseFocusRule     = False
myTerminal           = "${TERMINAL}"

{-
 -    web browsers become floating windows so that they aren't super
 -    easy to fingerprint.
 -
 -    otherwise, windows that correspond to specific programs are moved
 -    to certain workspaces to keep things organized.
 -}
myManageHook = composeAll
  [ className =? "Firefox" --> doShift "3"
  , className =? "Firefox" --> doCenterFloat
  , className =? "Tor Browser" --> doShift "4"
  , className =? "Tor Browser" --> doCenterFloat
  , className =? "KeePassXC" --> doShift "5"
  , className =? "Zathura" --> doShift "8"
  , className =? "mpv" --> doShift "9"
  , manageDocks ]

-- https://wiki.archlinux.org/title/Xmonad#Equally_sized_gaps_between_windows
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
