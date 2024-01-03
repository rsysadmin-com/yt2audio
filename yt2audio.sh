#!/bin/bash

# yt2audio.sh v0.0007
# 20230602 - martinm@rsysadmin.com
# 
# latest version on: https://github.com/rsysadmin-com/yt2audio
#
# this little script will search YouTube for the songs in the given URL or
# listed in # a text file, download and convert to mp3 (default) or 
# other audio formats in your current working directory.
# 
# requires: yt-dlp and ffmpeg
#
# due to the nature of the underlying tool (yt-dlp) it can also be used
# with other audio platforms, such as BandCamp (yt-dlp --list-extractors for more info)
#
#
# yt2audio.sh v0.0002
# 20160909 - martinm@rsysadmin.com
# 
# latest version on: https://github.com/rsysadmin-com/yt2audio
#
# this little script will search YouTube for the songs in the given URL or
# listed in # a text file, download and convert to mp3 (default) or 
# other audio formats in your current working directory.
# 
# requires: youtube-dl and ffmpeg
#
# due to the nature of the underlying tool (youtube-dl) it can also be used
# with other audio platforms, such as BandCamp (youtube-dl --list-extractors for more info)
#

# ====================================================================================
# DISCLAIMER: this tool is provided on an "AS IS" basis.
# The author is not to be held responsible for the use or misuse thereof.
# This wrapper script has been created in order to facilitate some common actions.
# ====================================================================================

# print a banner
#
echo -e "\n$(basename $0) - by Martin Mielke <martinm@rsysadmin.com>"
echo -e "=================================================="

# Set which downloader to use
ytbinary="yt-dlp"

# First, test if requirements are met
requirements="$ytbinary ffmpeg"
for r in $requirements
do
	which $r > /dev/null
	if [ -$? -ne 0 ]
	then
		echo -e "\nERROR - $r not found. Please install it and try again...\n"
		exit 1
	fi 
done

# define default audio format
# lame workaround but it works :-)
aformat=$4
if [ -z $aformat ]
then
	aformat=mp3
fi

function help {
    echo -e "\nUsage: $(basename $0) [-s] <URL> -p <URL-list> [-d] <songs.txt> [-l] <file.txt> -a <audio-format>\n"
    echo -e "\t-s URL \t\tdownload a single song"
	cat << EOF
			https://www.youtube.com/watch?v=XXXXXXXXX

EOF
	echo -e "\t-p URL-list \tdownload a play list"
	cat << EOF
			"https://www.youtube.com/watch?v=XXXXXXXXXX&list=YYYYYYYYYYYYYYYYYYY" (use quotes!)
			https://foo.bandcamp.com/album/bar
			
EOF
    echo -e "\t-d songs \tdownload songs as described in songs.txt"
    cat << EOF
    
			 songs.txt must be in the following format:

			 artist_1 - song_1
			 artist_2 - song_2
			 [...]
			 artist_n - song_n

			 i.e.: 	skinny puppy - assimilate
				genocide organ - ave satani
				haus arafna - new skin grafting

EOF
    echo -e "\t-l file \tdownload YouTube links listed in file.txt"
       cat << EOF
    
			 file.txt must be in the following format:
			 
				https://www.youtube.com/watch?v=descriptor_1
				https://www.youtube.com/watch?v=descriptor_2
				https://www.youtube.com/watch?v=descriptor_3
				[...]
				https://www.youtube.com/watch?v=descriptor_n

EOF
	echo -e "\t-a audio format"
		cat << EOF
		available options: 
			best
			aac
			vorbis
			mp3  <-- default
			m4a
			opus
			wav

EOF

    exit 1
}


if [ $# -eq 0 ]
then
	help
fi

function checkdefaults {
	# file containing the list of songs to be searched for and downloaded
	if [ -z $OPTARG ] 
	then
		help
	fi
}

function downloadSongsList {	# option -l
	checkdefaults
	cat $OPTARG |
	while read artist song
	do
		$ytbinary "ytsearch:$artist $song" -xc --audio-format $aformat -f bestaudio -o "%(title)s.%(ext)s"
	done
exit 

}

function downloadAllLinks {	# option -l
	checkdefaults
	$ytbinary -xc --audio-format $aformat -f bestaudio -o "%(title)s.%(ext)s" -a $OPTARG
}

function downloadPlayList {  # option -p
	checkdefaults
	$ytbinary -xc --audio-format $aformat --download-archive downloaded-list-items.txt -f bestaudio -o "%(title)s.%(ext)s"  $OPTARG 
}

function downloadSingleSong {  # option -s
	checkdefaults
	$ytbinary -xc --audio-format $aformat -f bestaudio -o "%(title)s.%(ext)s" $OPTARG
}

#
# main()
#
while getopts s:p:d:l:a:h OPT; do
  case $OPT in
    s)  # set option "s" (single song)
		downloadSingleSong
      	;;
	p)	# set uption "p" (all songs in a YT playlist)
		downloadPlayList
		;;
	l)	# set option "l" (batch mode for YouTube links in a file)
		downloadAllLinks
		;;
    d)  # set option "d" (batch mode for artist - song in a file)
 		# file containing the list of songs to be searched for and downloaded
		downloadSongsList
      	;;
	a)  # format
	    aformat=$4
        ;;
	h)
		help
		;;
    \?) #unrecognized option - show help
      #echo -e \\n"Option -${BOLD}$OPTARG${NORM} not allowed."
      #help
      #If you just want to display a simple error message instead of the full
      #help, remove the 2 lines above and uncomment the 2 lines below.
      echo -e "Use ${BOLD}$SCRIPT -h${NORM} to see the help documentation."\\n
      exit 2
      ;;
    "*")
		help
		;;
  esac
done

echo -e "\n All set!\n"
