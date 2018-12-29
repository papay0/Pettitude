import sys
import os

if len(sys.argv) != 2:
    print("Please write release or debug as an argument")
    sys.exit()

argument = sys.argv[1]
os.system("rm .firebaserc")
if argument == "release":
    os.system("cp config/.firebaserc_release .firebaserc")
elif argument == "debug":
    os.system("cp config/.firebaserc_debug .firebaserc")
else:
    print("Argument list is [release, debug]")
    sys.exit()
