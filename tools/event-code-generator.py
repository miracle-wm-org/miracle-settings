import re
import requests

url = "https://raw.githubusercontent.com/torvalds/linux/refs/heads/master/include/uapi/linux/input-event-codes.h"
response = requests.get(url)
text = response.text

pattern = re.compile(r'#define\s+(\w+)\s+(0x[0-9A-Fa-f]+|\d+)\b')

keycodes = {}
for match in pattern.finditer(text):
    name, value = match.groups()
    if name.startswith(("KEY_")):
        keycodes[name] = int(value, 0)  # Automatically handles hex and decimal

with open("linux_input_event_codes.dart", "w") as f:
    f.write("const Map<String, int> linuxInputEventCodes = {\n")
    for name, value in sorted(keycodes.items(), key=lambda x: x[1]):
        f.write(f"  '{name}': {value},\n")
    f.write("};\n")

print("Dart file generated: linux_input_event_codes.dart")
