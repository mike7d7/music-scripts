# music-scripts

## Description

Personal bash scripts used to compress and modify my music collection.
Currently it does the following:

- Trims silence at the start and end of every song.
- Adds ReplayGain tag for volume normalization.
- Compress to multiple formats to save space while maintaining quality.

## Usage

Clone repo

`https://gitlab.com/mike7d7/music-scripts.git`

Enter the directory

`cd music-scripts/`

Install dependencies or use the nix-shell (dependencies are listed in the shell.nix file)

`nix-shell`

Create a symlink to the folder with the original files.

`ln -s /home/user/path/to/original/folder/ original/`

Create a symlink to the folder with the processed files.
\*Example uses `opus/` folder, but depending on the script, this folder's name varies.

`ln -s /home/user/path/to/opus/folder/ opus/`

Run the desired script

`./process_opus.sh`

### process_single.sh

This script differs from the rest as it only processes only one file instead of all files in a folder.

Usage is as follows:
`./process_single.sh /home/user/path/to/song`

It will process the song and save it in the `opus/` folder, similarly to all the other scripts.
