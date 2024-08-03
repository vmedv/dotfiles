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
import XMonad.Util.ClickableWorkspaces
import qualified XMonad.StackSet as W
import XMonad.Util.SpawnOnce
import XMonad.Actions.SpawnOn
import XMonad.Actions.CopyWindow

-- myKeys :: XConfig -> List 
myKeys = 
 [ ((mod4Mask, xK_f), spawn "firefox") 
 , ((mod4Mask .|. shiftMask, xK_l), spawn "xsecurelock") 
 , ((0, xK_Print), spawn "flameshot gui")
 , ((mod1Mask, xK_space), spawn "rofi -show combi -combi-modes \"drun\"")
 , ((mod1Mask, xK_Tab), spawn "rofi -show window")
 , ((mod4Mask, xK_m), sendMessage $ JumpToLayout "monocle") --Switch to the full layout
 ]


myStartupHook :: X ()
myStartupHook = do
          spawnOn "3:" "~/.nix-profile/bin/telegram-desktop"
          spawnOn "4:" "~/.nix-profile/bin/spotify"
          spawnOn "2:" "~/.nix-profile/bin/firefox"
	  spawnOn "1:" "alacritty"

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "firefox"          --> doShift (myWorkspaces !! 1)
    , className =? "TelegramDesktop"  --> doShift (myWorkspaces !! 2)
    , className =? "Spotify"          --> doShift (myWorkspaces !! 3)
    , appName   =? "pavucontrol"      --> doCenterFloat
    , isDialog                        --> doCenterFloat
    , isFullscreen                    --> doFullFloat
    , insertPosition Master Newer
    ] 

myWorkspaces =  ["1:",
                 "2:",
                 "3:",
                 "4:",
                 "5:",
                 "6:","7:","8:","9:"]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
  where
        doubleLts '<' = "<<"
        doubleLts x   = [x]

myClickableWorkspaces :: [String]
myClickableWorkspaces = clickable . (map xmobarEscape)
           $ myWorkspaces
    where
        clickable l = [ "<action=`xdotool key super+" ++ show (n) ++ "`>" ++ ws ++ "</action>" |
                  (i,ws) <- zip [1..9] l,
                  let n = i ]

myConfig = def
    { terminal    = "alacritty"
    , workspaces  = myWorkspaces
    , modMask     = mod4Mask
    , layoutHook  = myLayout
    , manageHook  = myManageHook <+> doF W.swapDown <+> manageHook def
    , startupHook = myStartupHook
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
          $ ResizableTall 1 (1 / 100) (1 / 2) []

wide    = renamed [Replace "wide"]
          $ addTabs shrinkText myTabConfig . subLayout [] Simplest
          $ avoidStruts
          $ mySpacing 10
          $ Mirror
          $ ResizableTall 1 (1 / 100) (3 / 4) []

columns = renamed [Replace "columns"]
          $ addTabs shrinkText myTabConfig . subLayout [] Simplest
          $ avoidStruts
          $ mySpacing 10
          $ ThreeColMid 1 (1 / 100) (12 / 30)

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
    -- , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    -- , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 20

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""

mySB = statusBarProp "xmobar" (pure myXmobarPP)

main :: IO()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB mySB defToggleStrutsKey
     $ myConfig

