find . -maxdepth 1 -name '*.nc' -size -29M -exec bash -c 'cp  ./uncombined_files/$(basename -s .nc "$1")* .' _ {} \;
