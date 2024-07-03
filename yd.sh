#!/usr/bin/bash
red="\e[31m"
magenta="\e[35m"
endcolor="\e[0m"

echo -e "Hello dear user, this is a script that helps you download the desired youtube videos or playlists
from your terminal in various formats (currently mp3/mp4),but put in mind:
        ${red}1) Use this script on your own responsibilty
        2) Download YouTube videos freely, but only use ones that you have access to (e.g in editing...)
        3) With great power comes great responsibilty
        4) Enjoy ^_^${endcolor}
        "

main_script() {
error_message(){
    read -r -p "Invalid input dear user,would you like to try again ([y]yes or [n]no): " uretry
    retry=${uretry,,}
    if [[ $retry == "n" ]] || [[ $retry == "no" ]] ;then
        echo "Good bye :( "
        exit
    elif [[ $retry == "y" ]] || [[ $retry == "yes" ]] ;then
        echo "Okie,Dokie ;) "
        main_script
    else
        echo -e "${magenta}still not doing what should be done :_(${endcolor}"

    fi
}
end_msg(){
    echo "Done babyyyyyyyyyyy!"
}
info_perf(){
    read -r -p "Enter a valid YouTube URL: " url
    read -r -p "In which format would you like to download(mp3 or mp4): " mformat
    format=${mformat,,}
    if [[ $format == "mp3" ]]; then
        yt-dlp -x --audio-format mp3 "$url"
    elif [[ $format == "mp4" ]]; then
	    yt-dlp -f "bestvideo[ext=mp4][height<=?1080]+bestaudio[ext=m4a]/best[ext=mp4]/best" "$url"
    else
        error_message
    fi
}
read -r -p "What do you want to download from YouTube([p]playlist or [v]video):  " uoption
option=${uoption,,} #convert the user input into lowercase,so the code runs smoothly, then store it in a new variable called option
# echo $option ;test
if [[ $option == "p" ]] || [[ $option == "playlist" ]] ; then # || = or
    #echo "v works well";test
    read -r -p "What the folder containing the playlist's content should be named (if none, leave blank and press Enter): " foption
    if [[ -z $foption ]] ; then
        #echo "Works well" ;test
        info_perf
        end_msg
        exit
    else
        mkdir "$foption" && cd "$foption" || return
        info_pref
        end_msg
        exit
    fi
elif [[ $option == "v" ]] || [[ $option == "video" ]] ; then
    #echo "V Works well" ;test
    info_perf
    end_msg
    exit
else
    error_message
fi
}

read -r -p "Would you like to use the current directory as the installation one
if so leave blank and press enter, if no just input the desired derictory
                (e.g ~/Music ; ~/Videos): " dir
if [[ -z $dir ]];then
    main_script
else
    cd "$dir" || return
    main_script
fi
