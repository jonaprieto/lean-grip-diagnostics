#!/usr/bin/env python3
"""Mechanical Lean style gate used by CI."""

import subprocess
import sys

MAX = 100
try:
    files = subprocess.check_output(["rg", "--files", "-g", "*.lean"], text=True).split()
except FileNotFoundError:
    files = subprocess.check_output(["git", "ls-files", "*.lean"], text=True).split()
violations = []
for filename in files:
    for line_number, line in enumerate(open(filename, encoding="utf-8"), 1):
        line = line.rstrip("\n")
        if len(line) > MAX:
            violations.append(f"{filename}:{line_number}: line is {len(line)} cols (>{MAX})")
        if line != line.rstrip():
            violations.append(f"{filename}:{line_number}: trailing whitespace")
        if "\t" in line:
            violations.append(f"{filename}:{line_number}: tab character")

for violation in violations:
    print(violation)
print(f"{'FAIL' if violations else 'OK'}: {len(files)} Lean files, {len(violations)} violations")
sys.exit(1 if violations else 0)
