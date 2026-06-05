#!/usr/bin/env python3

import os
import sys
from datetime import datetime


os.chdir(os.path.dirname(os.path.realpath(__file__)))
root = os.getcwd()

version = datetime.now().strftime("%Y-%m-%d")


def freplace(f_path, search, replace):
	print(f"\nsetting version to {version} in {f_path}")

	replace = replace.replace("{v}", version)

	if not os.path.exists(f_path):
		print(f"\nWARNING: skipping update, file not found: {f_path}")
		return
	elif os.path.isdir(f_path):
		print(f"\nWARNING: skipping update, directory exists: {f_path}")
		return

	fin = open(f_path, "r", newline="\n")
	lines = fin.readlines()
	fin.close()

	# TODO: use regex on entire file

	text_orig = "".join(lines)
	found = False
	for idx in range(len(lines)):
		l = lines[idx]
		if l.startswith(search):
			lines[idx] = f"{replace}\n"
			found = True
			break

	if not found:
		print(f"\nWARNING: '{search}' text not found: {f_path}")
		return

	text_new = "".join(lines)
	if text_new == text_orig:
		print(f"\nWARNING: contents unchanged: {f_path}")
		return

	fout = open(f_path, "w", newline="\n")
	fout.write(text_new)
	fout.close()

	print("done")


if __name__ == "__main__":
	to_update = (
		("mod.conf", "version =", "version = {v}"),
		("changelog.txt", "next\n", "{v}"),
		# ~ (os.path.normpath(".ldoc/config.ld"), "local version =", "local version = {v}")
	)

	for x in to_update:
		f_path = os.path.join(root, x[0])

		freplace(f_path, x[1], x[2])

