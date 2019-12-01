#!/bin/bash

# yt2audio.sh v0.0002
# 20160909 - martin@mielke.com
# 
# this little script will search YouTube for the songs in the given URL or
# listed in # a text file, download and convert to mp3 (default) or 
# other audio formats.
# 
# due to the nature of the underlying tool (youtube-dl) it can also be used
# with other audio platforms, such as BandCamp (youtube-dl --list-extractors for more info)
#
# DISCLAIMER: this tool is provided on an "AS IS" basis.
# The author is not to be held responsible for the use or misuse thereof.
# This wrapper script has been created in order to facilitate some common actions.
# 

# First, test if requirements are met
if [ -z $(which youtube-dl) ]
then
    echo -e "\nERROR - please install youtube-dl and try again\n"
    exit 1
fi

# define default audio format
# lame workaround but it works :-)
aformat=$4
if [ -z $aformat ]
then
	aformat=mp3
fi

function help {
    echo -e "\nUsage: $(basename $0) [-u] <URL> -l <URL-list> [-b] <songs.txt> [-y] <ytlinks.txt>\n"
    echo -e "\t-u URL \t\tdownload a single song from YouTube\n"
	echo -e "\t-l URL-list \tdownload a play list"
	cat << EOF
			https://www.youtube.com/watch?v=XXXXXXXXXX&list=YYYYYYYYYYYYYYYYYYY
			https://foo.bandcamp.com/album/bar
			
EOF
    echo -e "\t-b songs \tdownload songs as described in songs.txt"
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
    echo -e "\t-y file \tdownload YouTube links listed in file.txt"
       cat << EOF
    
			 ytlinks.txt must be in the following format:
			 
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

function downloadTxtList {	# option -b
	checkdefaults
	cat $OPTARG |
	while read artist song
	do
		youtube-dl "ytsearch:$artist $song" -xc --audio-format $aformat --audio-quality 0 -o "%(title)s.%(ext)s"
	done
exit 

}

function downloadYTLink {	# option -y
	checkdefaults
	echo FORMAT $aformat
	youtube-dl -xc --audio-format $aformat --audio-quality 0 -o "%(title)s.%(ext)s" -a $OPTARG
}

function downloadYTList {  # option -l
	checkdefaults
	youtube-dl -xc --audio-format $aformat --download-archive downloaded-list-items.txt --audio-quality 0 -o "%(title)s.%(ext)s"  $OPTARG 
}

function downloadSingleLink {  # option -u
	checkdefaults
	youtube-dl -xc --audio-format $aformat --audio-quality 0 -o "%(title)s.%(ext)s" $OPTARG
}

# to-do: verify missing downloads from the list
# to-do: point out wrongly downloaded songs

while getopts :u:l:b:y:a:h OPT; do
  case $OPT in
    u)  # set option "u" (unique song)
		downloadSingleLink
      	;;
	l)	# set uption "l" (all songs in a YT list)
		downloadYTList
		;;
	y)	# set option "y" (batch mode for YouTube links in a file)
		downloadYTLink
		;;
    b)  # set option "b" (batch mode for artist - song in a file)
 		# file containing the list of songs to be searched for and downloaded
		downloadTxtList
      	;;
	a)  # format
	        aformat=$3
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
