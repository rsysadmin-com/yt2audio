# yt2audio

`yt2audio` is a little Bash wrapper around ~~youtube-dl~~ `yt-dlp` which helps you to grab audio tracks from YouTube videos, and other providers, and convert them to a given list of popular formats (default=MP3).

Files will be downloaded to the current working directory. If you plan to download a playlist, I suggest you to create a directory for it first...

## usage
       yt2audio.sh [-s] <URL> -p <URL-list> [-d] <songs.txt> [-l] <file.txt> -a <audio-format>

        -s URL          download a single song
                        https://www.youtube.com/watch?v=XXXXXXXXX

        -p URL-list     download a play list
                        "https://www.youtube.com/watch?v=XXXXXXXXXX&list=YYYYYYYYYYYYYYYYYYY" <-- between double quotes!
                        https://foo.bandcamp.com/album/bar

        -d songs        download songs as described in songs.txt
    
                         songs.txt must be in the following format:

                         artist_1 - song_1
                         artist_2 - song_2
                         [...]
                         artist_n - song_n

                         i.e.:  skinny puppy - assimilate
                                genocide organ - ave satani
                                haus arafna - new skin grafting

        -l file         download YouTube links listed in file.txt
    
                         file.txt must be in the following format:
                         
                                https://www.youtube.com/watch?v=descriptor_1
                                https://www.youtube.com/watch?v=descriptor_2
                                https://www.youtube.com/watch?v=descriptor_3
                                [...]
                                https://www.youtube.com/watch?v=descriptor_n

        -a audio format
                available options: 
                        best
                        aac
                        vorbis
                        mp3  <-- default
                        m4a
                        opus
                        wav


Wherever you see "YouTube" you may use other providers. Please run ~~youtube-dl~~ `yt-dpl --list-extractors` to see the list of all supported platforms.

NOTE: please, keep in mind that `yt2audio` relies on `yt-dlp`, so if a certain provider is not supported by the latter, it won't be available from the former either.

## disturbances in The Force
Sometimes you may list an artist or a song and you could get something totally unrelated if what you are looking for is not available. I would suggest you to try searching on, say, YouTube first to check whether the tune exists... if not, just enjoy the new (unknown?) songs :-)

Every now and then, the script will fail and it won't be able to download anything from anywhere.<p>
Most likely, you only will need to update it. <p>
If you installed `yt-dlp` using your system's package manager, I recommend you to update it using it as well, otherwise you will see an error message like this:

```
$ yt-dlp -U                     
Current version: stable@2023.11.16 from yt-dlp/yt-dlp
Latest version: stable@2023.12.30 from yt-dlp/yt-dlp
ERROR: You installed yt-dlp with a package manager or setup.py; Use that to update
```

## requirements
`yt2audio` needs ~~youtube-dl~~ `yt-dlp` to handle all the downloads, and `ffmpeg` for audio format conversions, so they need to be installed on your system.<p>
You can install both using your system's software management tool (i.e.: zypper, yum, apt, dnf...)<p>

## disclaimer
This script was created out of lazynes so I did not need to memorize all the options I had to use in order to extract audio tracks from videos. <p>
It is provided on an "AS IS" basis. The author is not to be held responsible for the use or misuse thereof.
