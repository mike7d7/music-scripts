#!/bin/sh

script_dir=$(dirname "$0")
source_folder="$script_dir/original"
destination_folder="$script_dir/flac"

mkdir -p "$destination_folder"

process_file() {
        file="$1"
        only_name="$(basename "$file")"
        file_without_extension="${only_name%.*}"

        rsgain custom -s 'i' -l '-18' "$file"

        GAIN=$(ffprobe -v error -show_entries format_tags=REPLAYGAIN_TRACK_GAIN \
                -of default=noprint_wrappers=1:nokey=1 "$file" | sed 's/ dB//')
        ffmpeg -v quiet -i "$file" -af "silenceremove=start_periods=1:start_silence=1.5:start_threshold=-30dB,areverse,silenceremove=start_periods=1:start_silence=1.5:start_threshold=-30dB,areverse,volume=${GAIN}dB" -c:a flac -compression_level 10 "$destination_folder/$file_without_extension.flac"

        # Use kid3-cli to manage metadata
        kid3-cli -c "select \"$file\"" -c "copy 2" -c "select \"$destination_folder/$file_without_extension.flac\"" -c "paste 2" -c "save"
}

max_jobs=$(nproc)
current_jobs=0

for file in "$source_folder"/*; do
        process_file "$file" &
        current_jobs=$((current_jobs + 1))

        if [ "$current_jobs" -ge "$max_jobs" ]; then
                wait -n
                current_jobs=$((current_jobs - 1))
        fi
done

wait
