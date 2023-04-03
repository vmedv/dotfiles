-- Imports.
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.Loggers
import XMonad.ManageHook
import XMonad.Hooks.ManageHelpers
import Control.Monad (liftM2)
import XMonad.Layout.LayoutCombinators ((|||), JumpToLayout (JumpToLayout))
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.MultiToggle (mkToggle, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (NBFULL, NOBORDERS))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile (MirrorResize (..), ResizableTall (ResizableTall))
import XMonad.Layout.Spacing (Border (Border), Spacing, spacingRaw)
import XMonad.Layout.Tabbed (Theme (..), addTabs, shrinkText)
import XMonad.Layout.ThreeColumns (ThreeCol (ThreeColMid))
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Simplest (Simplest (..))
import XMonad.Layout.SubLayouts (GroupMsg (UnMerge), mergeDir, onGroup, subLayout)
import XMonad.Layout.WorkspaceDir (changeDir, workspaceDir)
import XMonad.Hooks.InsertPosition

import qualified XMonad.StackSet as W


-- myKeys :: XConfig -> List 
myKeys = 
 [ ((mod4Mask, xK_f), spawn "firefox")
 , ((mod4Mask, xK_s), spawn "steam")
 , ((mod4Mask .|. shiftMask, xK_l), spawn "xsecurelock") 
 , ((0, xK_Print), spawn "flameshot gui")
 ]

--myManageHook = composeAll
--    [ className =? "spotify" --> doFloat
--    , isDialog               --> doFloat
--    ]


myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Vivaldi-stable"   --> doShift (myWorkspaces !! 0)
    , className =? "telegram-desktop" --> doShift (myWorkspaces !! 2)
    , className =? "discord"          --> doShift (myWorkspaces !! 2)
    , className =? "mpv"              --> doShift (myWorkspaces !! 3)
    , className =? "spotify"          --> doShift (myWorkspaces !! 2)
    , className =? "Lua5.1"           --> doCenterFloat
    , className =? "Peek"             --> doCenterFloat
    , isDialog                        --> doCenterFloat
    , isFullscreen                    --> doFullFloat
    , insertPosition Master Newer
    ] 

myWorkspaces =  ["1:web","2:dev","3:soc","4:vid","5","6","7","8","9","0"]

myConfig = def
    { terminal    = "alacritty"
    , workspaces  = myWorkspaces
    , modMask     = mod4Mask
    , layoutHook  = myLayout
    , manageHook  = myManageHook <+> manageHook def
--    , handleEventHook = fullscreenEventHook
    } `additionalKeys` myKeys

myTabConfig :: Theme
myTabConfig = def 

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw True (Border 0 i 0 i) True (Border i 0 i 0) True

monocle = renamed [Replace "monocle"]
          $ avoidStruts
          $ noBorders
          $ Full

tall    = renamed [Replace "tall"]
          $ addTabs shrinkText myTabConfig . subLayout [] Simplest
          $ avoidStruts
          $ mySpacing 10
          $ ResizableTall 1 (3 / 100) (1 / 2) []

wide    = renamed [Replace "wide"]
          $ addTabs shrinkText myTabConfig . subLayout [] Simplest
          $ avoidStruts
          $ mySpacing 10
          $ Mirror
          $ ResizableTall 1 (3 / 100) (3 / 4) []

columns = renamed [Replace "columns"]
          $ addTabs shrinkText myTabConfig . subLayout [] Simplest
          $ avoidStruts
          $ mySpacing 10
          $ ThreeColMid 1 (3 / 100) (12 / 30)

myLayout = workspaceDir "/home/vmedv"
               $ smartBorders
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT)
               $ firstLayout . secondLayout . thirdLayout $ myDefaultLayout
             where
               firstLayout  = onWorkspace "Highway"       (monocle ||| tall ||| wide    ||| columns)
               secondLayout = onWorkspace "Communication" (tall    ||| wide ||| columns ||| monocle)
               thirdLayout  = onWorkspace "Development"   (columns ||| tall ||| wide    ||| monocle)
               myDefaultLayout =      tall
                                  ||| wide
                                  ||| columns
                                  ||| monocle

myXmobarPP :: PP
myXmobarPP = def
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
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 40

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

main :: IO()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

