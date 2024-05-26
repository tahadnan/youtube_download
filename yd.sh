#/usr/bin/bash
echo -n "Hello dear user, enter the YouTube video url that you'd like to download: "
read vurl
echo -n "In which Format (mp3/mp4): "
read format
echo -n "Specify the dir to download in: "
read dir
# if [$format == mp3];then
#     yt-dlp -o "$dir" -x --audio-format mp3 $vurl
# fi #I used mp3 instead of "mp3"

if [ "$format" == "mp3" ]; then
    yt-dlp -o "$dir/%(title)s.%(ext)s" -x --audio-format mp3 "$vurl"
elif [ "$format" == "mp4" ]; then
    yt-dlp -o "$dir/%(title)s.%(ext)s" -f mp4 "$vurl"
else
    echo "Invalid format specified. Please use 'mp3' or 'mp4'."
fi
