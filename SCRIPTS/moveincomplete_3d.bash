mkdir -p incompletefiles
find . -maxdepth 1 -name '*.nc' -size -721M -exec mv {} incompletefiles/ \;
