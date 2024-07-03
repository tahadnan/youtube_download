#!/usr/bin/bash

# Define color codes
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
magenta="\e[35m"
endcolor="\e[0m"

# Function to check if yt-dlp is installed
check_dependencies() {
    if ! command -v yt-dlp &> /dev/null; then
        echo -e "${red}Error: yt-dlp is not installed.${endcolor}"
        echo "Please install it using: pip install yt-dlp"
        exit 1
    fi
}

# Function to display welcome message
display_welcome_message() {
    echo -e "${green}YouTube Downloader Script${endcolor}"
    echo -e "This script helps you download YouTube videos or playlists in various formats."
    echo -e "${yellow}Note:${endcolor}"
    echo -e "1) Use this script responsibly"
    echo -e "2) Only download videos you have the right to access"
    echo -e "3) With great power comes great responsibility"
    echo -e "4) Enjoy ^_^"
    echo
}

# Function to validate YouTube URL
validate_url() {
    local url=$1
    if [[ $url =~ ^https?://((www\.)?youtube\.com|youtu\.be) ]]; then
        return 0
    else
        return 1
    fi
}

# Function to get download directory
get_download_directory() {
    read -r -p "Enter download directory (leave blank for current directory): " dir
    if [[ -z $dir ]]; then
        dir="."
    fi
    if [[ ! -d $dir ]]; then
        echo -e "${yellow}Directory doesn't exist. Creating it...${endcolor}"
        mkdir -p "$dir"
    fi
    cd "$dir" || exit
}

# Function to download video
download_video() {
    local url=$1
    local format=$2
    local output_template="%(title)s.%(ext)s"

    if [[ $format == "mp3" ]]; then
        yt-dlp -x --audio-format mp3 --output "$output_template" "$url"
    elif [[ $format == "mp4" ]]; then
        read -r -p "Enter video quality (144/240/360/480/720/1080): " quality
        yt-dlp -f "bestvideo[height<=?$quality]+bestaudio/best" --merge-output-format mp4 --output "$output_template" "$url"
    fi
}

# Function to download playlist
download_playlist() {
    local url=$1
    local format=$2
    local output_template="%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"

    if [[ $format == "mp3" ]]; then
        yt-dlp -x --audio-format mp3 --output "$output_template" "$url"
    elif [[ $format == "mp4" ]]; then
        read -r -p "Enter video quality (144/240/360/480/720/1080): " quality
        yt-dlp -f "bestvideo[height<=?$quality]+bestaudio/best" --merge-output-format mp4 --output "$output_template" "$url"
    fi
}

# Main function
main() {
    check_dependencies
    display_welcome_message
    get_download_directory

    while true; do
        read -r -p "Download [v]ideo, [p]laylist, or [q]uit: " choice
        choice=${choice,,}

        case $choice in
            v|video)
                read -r -p "Enter YouTube URL: " url
                if ! validate_url "$url"; then
                    echo -e "${red}Invalid YouTube URL${endcolor}"
                    continue
                fi
                read -r -p "Choose format (mp3/mp4): " format
                format=${format,,}
                if [[ $format != "mp3" && $format != "mp4" ]]; then
                    echo -e "${red}Invalid format. Please choose mp3 or mp4.${endcolor}"
                    continue
                fi
                download_video "$url" "$format"
                ;;
            p|playlist)
                read -r -p "Enter YouTube playlist URL: " url
                if ! validate_url "$url"; then
                    echo -e "${red}Invalid YouTube URL${endcolor}"
                    continue
                fi
                read -r -p "Choose format (mp3/mp4): " format
                format=${format,,}
                if [[ $format != "mp3" && $format != "mp4" ]]; then
                    echo -e "${red}Invalid format. Please choose mp3 or mp4.${endcolor}"
                    continue
                fi
                download_playlist "$url" "$format"
                ;;
            q|quit)
                echo "Thank you for using the YouTube Downloader. Goodbye!"
                exit 0
                ;;
            *)
                echo -e "${red}Invalid choice. Please choose v, p, or q.${endcolor}"
                ;;
        esac
    done
}

# Run the main function
main
