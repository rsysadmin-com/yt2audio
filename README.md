# yt2audio

yt2audio is a little Bash wrapper around youtube-dl which helps you to grab audio track from YouTube videos and convert them to MP3.

## usage
Usage: yt2audio.sh [-u] <URL> [-l] <URL-list> [-b] <songs.txt> [-y] <ytlinks.txt>

        -u URL          download a single song from YouTube

        -l URL-list     download a play list
                        https://www.youtube.com/watch?v=XXXXXXXXXX&list=YYYYYYYYYYYYYYYYYYY
                        https://foo.bandcamp.com/album/bar

        -b songs        download songs as described in songs.txt
    
                         songs.txt must be in the following format:

                         artist_1 - song_1
                         artist_2 - song_2
                         [...]
                         artist_n - song_n

                         i.e.:  skinny puppy - assimilate
                                genocide organ - ave satani
                                haus arafna - new skin grafting

        -y file         download YouTube links listed in file.txt
    
                         ytlinks.txt must be in the following format:
                         
                                https://www.youtube.com/watch?v=descriptor_1
                                https://www.youtube.com/watch?v=descriptor_2
                                https://www.youtube.com/watch?v=descriptor_3
                                [...]
                                https://www.youtube.com/watch?v=descriptor_n



Wherever you see "YouTube" you may use other providers. Please run youtube-dl --list-extractors to see the list of supported platforms.

## disturbances in The Force
sometimes you may list an artist or a song and you could get something totally unrelated if what you are looking for is not available. I would suggest you to try searching on, say, YouTube first to check whether the tune exists... if not, just enjoy the new (unknown?) songs :-)

## requierements
yt2audio needs youtube-dl to handle all the downloads and ffmpeg for audio format conversions so they need to be installed on your system.<p>
You can install both using your system's software management tool (i.e.: zypper, yum, apt, dnf...)<p>

## disclaimer
This script was created out of lazynes so I did not need to memorize all the options I had to use in order to rip audio tracks from videos. It is provided on an "AS IS" basis. The author is not to be held responsible for the use or misuse thereof.
