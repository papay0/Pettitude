python $PWD/tooling/localizations/check_localizations.py

if [ $? == 1 ]; then
    exit 0
else
    exit 1
fi
