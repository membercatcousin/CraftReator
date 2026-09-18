import os

ROOT = os.path.expanduser("~/Projects/multilang/CraftReator")  # CHANGE THIS to your actual path

REVERSE = {
    "CraftReator": "MCreator",
    "Minecraft mod making toolkit developed by Akram": "Minecraft mod making toolkit developed by Pylo",
}

SKIP_DIRS = {".git", "build", "out", ".gradle", "node_modules", ".idea"}

def process_file(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            content = f.read()
    except (UnicodeDecodeError, PermissionError):
        return False

    original = content
    for old, new in REVERSE.items():
        content = content.replace(old, new)

    if content != original:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        return True
    return False

def main():
    changed = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            if name.endswith((".properties", ".java", ".ftl", ".json", ".html", ".txt", ".xml", ".gradle", ".md")):
                full = os.path.join(dirpath, name)
                if process_file(full):
                    changed.append(full)

    print(f"Reverted {len(changed)} files:")
    for f in changed:
        print(f"  {f}")

if __name__ == "__main__":
    main()
