import subprocess
import os

ROOT = os.path.expanduser("~/Projects/multilang/CraftReator")
LOG_FILE = os.path.expanduser("~/splash_search.log")

COMMANDS = [
    ["grep", "-rn", "mod making toolkit", ROOT, "--exclude-dir=.git", "--exclude-dir=build"],
    ["grep", "-rn", "registered trademark", ROOT, "--exclude-dir=.git", "--exclude-dir=build"],
    ["grep", "-rn", "developed by", ROOT, "--exclude-dir=.git", "--exclude-dir=build"],
    ["find", ROOT, "-iname", "*splash*", "-not", "-path", "*/build/*"],
    ["grep", "-rln", "Pylo", ROOT, "--include=*.java", "--exclude-dir=.git", "--exclude-dir=build"],
]

with open(LOG_FILE, "w", encoding="utf-8") as log:
    for cmd in COMMANDS:
        log.write(f"\n{'='*70}\n")
        log.write(f"COMMAND: {' '.join(cmd)}\n")
        log.write(f"{'='*70}\n")
        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=60)
            if result.stdout.strip():
                log.write(result.stdout)
            else:
                log.write("(no output)\n")
            if result.stderr.strip():
                log.write(f"\n[stderr]\n{result.stderr}")
        except subprocess.TimeoutExpired:
            log.write("(command timed out)\n")
        except FileNotFoundError:
            log.write(f"(command not found: {cmd[0]})\n")

print(f"Log written to: {LOG_FILE}")
print(f"Open it with: cat {LOG_FILE}")
