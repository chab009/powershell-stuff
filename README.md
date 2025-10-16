# powershell-stuff
powershell-stuff

**plex-MP4stutterfix.ps1**

Issue:
Certain MP4 files in plex that were encoded from RARBG experience video stuttering when played in Plex as Direct Play/Direct Stream in Original Quality, the audio remains consistent. However, the video works fine when transcoded. 

When the MP4 file is multiplexed through MKVToolNix as an MKV file, the metadata is repaired and the video no longer stutters.

Description:
The powershell script will utilize MediaInfo's CLI tool to look for the Encoded_Library (Writing library) tag under the Video branch within the media files metadata. If this is found, the path to the file will be saved in a text file. Each time a new media file is found with this tag, it will be appended to the text file. Once the scan is complete, this text file will be fed in to MKVToolNix's mkvmerge executable in order to repair the file. Filenames will rename the same, extensions will be changed to MKV. **After a file is converted, the original MP4 will be deleted.** 

Depending on the amount of media files, MediaInfo could take minutes to hours to complete the initial scan.

The multiplexing process takes 1-2 minutes per file, and can take hours to days for a large library, however the resource usage is relatively low.

Environment Created On:
Windows 10 Pro 22H2 64-bit

Requirements:
Windows & Powershell
MediaInfo CLI Version for Windows: https://mediaarea.net/en/MediaInfo/Download/Windows
MKVToolNix for Windows: https://mkvtoolnix.download/downloads.html#windows
