#!/bin/bash
# Redirect all stdout and stderr to a log file
exec >> $(echo "${0##(*/|.*)}"".log") 2>&1
date


# Provide full path to roms here.
content_path="/Content/"

#CSV from: https://github.com/IronRingX/xbox360-gamelist
file="xbox360_gamelist.csv"
[[ -e $file ]] || wget https://github.com/IronRingX/xbox360-gamelist/raw/32aae7abeff7ed47969786309739444eb5397731/xbox360_gamelist.csv



#I had trouble with globbing find into a symbolic link. Might not be necessary with correct content_path
shopt -s globstar
shopt | grep globstar
echo -e "\n\n"

# Find all directories matching the pattern and process each one
find $content_path -type f \( -ipath "**/000d0000/*" -o -path "**/00007000/*" -not -ipath "*.data/*" \) | while read dir; do
    # Extract the title from the directory path
    dir="$(readlink -f "$dir")"

    title=$(echo "${dir^^}" | cut -d'/' -f 1- --output-delimiter=$'\n' | tail -n 3 | head -n 1)

    echo "Parsing: $title"
    echo "Full Path: $dir"
    # Parse the CSV file to find the matching game name and title ID

    while IFS=, read -r Game_Name Title_ID Serial Type Region XEX_CRC Media_ID Wave; do
        if [[ "$Title_ID" == "$title" ]]; then
            #special case due to illegal characters in csv
            title=$( echo "${Game_Name//[^a-zA-Z0-9.\'! _()-]/}" )
            echo "Processing: $Game_Name"  >/dev/tty
            echo "Game Name: $Game_Name"
            echo "Title ID: $Title_ID"
            echo "Creating:" "./${Type,,}/${title:0:244} [$Title_ID]"
            mkdir -p "./${Type,,}"
            ln -s "$(readlink -f "$dir")" "./${Type,,}/${title:0:244} [$Title_ID]"
            echo -e "\n\n"
            break
        elif [[ "$Title_ID" == "" ]]; then
            echo "----------------------- Error! Could not find game! -----------------------"   | tee  /dev/tty >&2
            echo "FAILED to process: $title at $dir"   | tee  /dev/tty >&2
            echo -e "\n\n"
        fi
    done < "$file"
done
