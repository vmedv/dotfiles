Config { overrideRedirect = False
       , font     = "xft:Iosevka Comfy:style=Bold:size=10"
       , additionalFonts  = ["xft:FontAwesome:size=10"]
       , bgColor  = "#121212"
       , alpha = 0
       , fgColor  = "#f8f8f2"
       , position = Top
       , commands = [ Run Date "%a %Y-%m-%d <fc=#8be9fd>%l:%M:%S %p</fc>" "date" 10
                    , Run Battery        [
                    "-t", "<fn=1>\xf240</fn>: <acstatus>(<left>%)",
                    "-L", "10", "-H", "80", "-p", "3",
                    "--", "-O", "<fc=green>On</fc> - ", "-i", "",
                    "-L", "-15", "-H", "-5",
                    "-l", "red", "-m", "blue", "-h", "green",
                    "-a", 
                    "-A", "5"
                             ] 10
                    , Run XMonadLog
                    , Run UnsafeStdinReader
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = "%XMonadLog% } %date% { <action=`pavucontrol`><fn=1>aud</fn></action> %battery% "
       }
