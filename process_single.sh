#!/bin/sh

script_dir=$(dirname "$0")
source_folder="$script_dir/original"
destination_folder="$script_dir/opus"

mkdir -p "$destination_folder"

process_file() {
    file="$1"
    only_name="$(basename "$file")"
    file_without_extension="${only_name%.*}"

    ffmpeg -i "$file" -af "silenceremove=start_periods=1:start_silence=1.5:start_threshold=-30dB,areverse,silenceremove=start_periods=1:start_silence=1.5:start_threshold=-30dB,areverse" -c:a libopus -b:a 128k "$destination_folder/$file_without_extension.opus"

    # Use kid3-cli to copy metadata from the original file
    kid3-cli -c "select \"$file\"" -c "copy 2" -c "select \"$destination_folder/$file_without_extension.opus\"" -c "paste 2" -c "save"

    # Set volume using rsgain
    rsgain custom -s 'i' -l '-18' -o 't' "$destination_folder/$file_without_extension.opus"
}

process_file "$input_file"
