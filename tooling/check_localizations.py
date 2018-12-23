#!/usr/bin/python
import os

print("This is a failing test")
os.system("echo from python")
os.system("exit 1")
