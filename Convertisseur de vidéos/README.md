
## Using the script

This script can be used with a few parameters to be passed on to the script.
	
	- directory_to_scan : 
		==> Self-explanatory, the absolute path of the folder containing the videos to convert. 
		==> Default to "E:\Convert" if not precised
	- extension_to_convert : 
		==> The extension of the videos which are to be converted. 
		==> Default to "avi" if not precised
	- extension_to_convert_to : 
		==> The extension to convert the videos to. 
		==> Default to "webm" if not precised
	- quality: 
		==> The overall quality of the conversion. 
		==> Default to good if not precised.
	- cpu_used: 
		==> The number of cpu used during the conversion. Affect the speed of the conversion. Has to be inferior to your real number of cores -1 (if you want to continue to use your computer). 
		==> Default to 3 if not precised.
	- deadline: 
		==> Heavily affect the speed to the conversion, but the more speedy the conversion is, the more crappy the conversion become. Possible values: "best", "good" and "realtime". 
		==> Default to "realtime" if not precised.
	- resolution: 
		==> The height of your wideo. 
		==> Default to 1080 (HD) if not precised.
	- threads: 
		==> Numbers of threads launched during the conversion. Has to be inferior to your number of thread. 
		==> Default to 3 if not precised.

## Code Example

Default settings for me :
	Open a powershell instance, cd to the dir of the script, make sure that ffmpeg.exe is right next to the script and...

	.\Convert.ps1

Example Parametred call to convert all the .avi videos in folder "C:\test" to .webm with a "good" quality in 1080p, using 2 cpu with 3 threads:

	.\Convert.ps1 -directory_to_scan "C:\test" -extension_to_convert "avi" -extension_to_convert_to "webm" -quality "good" -cpu_used 2 -deadline "realtime" -resolution 1080 -threads 3