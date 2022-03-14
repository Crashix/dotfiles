import XMonad

import XMonad.Config.Azerty

import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab
import XMonad.Util.Run
import XMonad.Util.SpawnOnce


main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar ~/.config/xmobar/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig


myConfig = def
           { terminal    = myTerminal,
             modMask     = mod4Mask,
             layoutHook  = myLayout,
             keys        = \c -> azertyKeys c <+> keys def c,  -- Use fr keybindings
             startupHook = myStartupHook
           }
           `additionalKeysP`
           [
             ("M-S-f",           spawn "firefox"),
             ("M-S-<Return>",    spawn myTerminal),
             ("M-S-d",           spawn "emacs"),
             ("M-S-e",           spawn "thunar"),
             ("M-S-=", unGrab *> spawn "scrot -s"),
             ("M-S-k",           spawn "keepassxc")
           ]

myLayout = tiled ||| Mirror tiled ||| threeCol ||| Full
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled   = Tall nmaster delta ratio
    nmaster = 1      -- Default number of windows in the master pane
    ratio   = 1/2    -- Default proportion of screen occupied by master pane
    delta   = 3/100  -- Percent of screen to increment by when resizing panes

myXmobarPP :: PP
myXmobarPP =  def
              { ppSep             = magenta " • "
              , ppTitleSanitize   = xmobarStrip
              , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
              , ppHidden          = white . wrap " " ""
              , ppHiddenNoWindows = lowWhite . wrap " " ""
              , ppUrgent          = red . wrap (yellow "!") (yellow "!")
              , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
              , ppExtras          = [logTitles formatFocused formatUnfocused]
              }
            where
              formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
              formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow


              -- | Windows should have *some* title, which should not not exceed a
              -- sane length.
              ppWindow :: String -> String
              ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30


              blue, lowWhite, magenta, red, white, yellow :: String -> String
              magenta  = xmobarColor "#ff79c6" ""
              blue     = xmobarColor "#bd93f9" ""
              white    = xmobarColor "#f8f8f2" ""
              yellow   = xmobarColor "#f1fa8c" ""
              red      = xmobarColor "#ff5555" ""
              lowWhite = xmobarColor "#bbbbbb" ""

myStartupHook = do
                -- | Set X Keyboard Layout:
                spawnOnce "setxkbmap fr"

                -- | Set up an icon tray:
                spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true \
                          \ --expand true --width 10 --transparent true --tint 0x5f5f5f --height 20 & "

                -- | Set the default X cursor to the usual pointer:
                spawnOnce "xsetroot -cursor_name left_ptr"

                -- | Set the background:
                spawnOnce ("feh --bg-fill --no-fehbg " ++ myWallpaper)









myTerminal  :: String
myTerminal  = "kitty"

myWallpaper :: String
myWallpaper = "~/.wallpapers/touhou_clouds_hat_jikan_hakushaku_katana_konpaku_youmu_leaves_scenic_shorts\
                \_sword_touhou_weapon_1440x1007.jpg"
