#!/usr/bin/python
import re
import sys

default_language = "en"
available_languages = ["fr"]
suffix = ".lproj/Localizable.strings"
path_localization_files = "Pettitude/Resources/Localizations/"

success = 1

def get_keys(path):
    lines = open(path, "r").read()
    dict = {}
    matches = re.findall(r'\"(.+?)\" = \"(.+?)\";', lines)
    for (key, value) in matches:
        dict[key] = 1
    return dict

default_keys = get_keys(path_localization_files + default_language + suffix)
set_default_keys = set(default_keys)
for language in available_languages:
    dict_keys = get_keys(path_localization_files + language + suffix)
    set_keys = set(dict_keys)
    if dict_keys != default_keys:
        print(language + " - some keys are missing")
        print(set_default_keys - set_keys)
        success = 0

if success:
    sys.exit(1)
else:
    sys.exit(0)
