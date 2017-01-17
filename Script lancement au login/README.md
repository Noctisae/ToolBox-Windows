
## Using the scripts

This tweak is composed of 2 scripts:
	- add_script_to_login.ps1 make 2 things:
			- Add to the Windows PATH two paths, which usually contains shortcuts for programs ('C:\ProgramData\Microsoft\Windows\Start Menu\Programs' and "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs", where $user is your username). The script also recursively descend into the folders of theses two folders and copy all the shortcut to the base of the folder (to avoid to pollute the Windows PATH, which has issues, with dozens of folders).
			- Create a scheduled task which will trigger at all your future login. This scheduled task launch script_to_play.ps1 each time you login on your session.

	- script_to_play.ps1 can be modified to actually do what you want when you login (I personnally launch some programs like Steam or Spotify, but this script can basically play anything on login).

## Things to know

The scheduled task created by the first script remember the folder where you launched the script add_script_to_login.ps1 to launch the script_to_play.ps1. So if you change the folder of the script, make sure to change the path of the script in the command of the scheduled task.

The add_script_to_login.ps1 actually change your Windows PATH to include all programs detected by Windows as installed on your computer. If you're not okay with that, don't launch it.

Tested and certified on Windows 10, should work on all Windows down to Windows 7.

https://superuser.com/questions/1070272/why-does-windows-have-a-limit-on-environment-variables-at-all