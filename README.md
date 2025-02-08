This is a powershell script to convert m4a files to mp3.
Pre-requisite: ffmpeg installed and added to system path.
Sample tutorial for installing and configuring ffmpeg on windows: https://www.wikihow.com/Install-FFmpeg-on-Windows

Usage: 
1. Open a powershell window on your machine
2. Run the script by typing this command: .\convert_m4a_to_mp3.ps1 -inputpath "yourinputlocation" -outputpath "locationforconvertedfiles".

Where:
"yourinputlocation" -> path of the folder containing music files which you want to convert.
"locationforconvertedfiles" -> path of the folder to save the resulting files after conversion to mp3 format.
