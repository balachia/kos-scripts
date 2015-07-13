#!/usr/local/bin/python
import subprocess
import re

out = subprocess.check_output(["ckan","list"])
outlines = out.split("\n")

mods = re.findall(r'\n[-X?^] ([a-zA-Z-_0-9]+)',out)

print mods

subprocess.call(['ckan','remove'] + mods)


