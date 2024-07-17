#!/usr/bin/env python 

import subprocess
import json

output = subprocess.check_output("wpctl get-volume @DEFAULT_AUDIO_SOURCE@", shell=True)
inspect = subprocess.check_output("wpctl inspect @DEFAULT_AUDIO_SOURCE@ | grep node.nick | cut -d \"\\\"\" -f2", shell=True)

is_muted = len(output) > 13
ret = {}
if is_muted:
    ret["text"] = ""
    ret["alt"] = "muted"
    ret["class"] = "muted"
else:
    ret["text"] = str(int(100 * float(output[8:12].decode()))) + "%"
    ret["alt"] = "unmuted"


ret["tooltip"] = inspect.decode().strip() 

# text = str(int(100 * float(output[8:12].decode()))) + "% " if len(output) <= 13 else ""
# ret = {
#    "text": text, 
#    "alt": "muted" if len(output) > 13 else "unmuted",
#    "tooltip": "dummy",
#    "class": "muted" if len(output) > 13 else "unmuted",
#    "percentage": 100,
# }
# {"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": $percentage }
print(json.dumps(ret))
