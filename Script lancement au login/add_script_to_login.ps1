$CWD = Convert-Path .

$path = $Env:Path;

#Ajout des raccourcis Start-up de Windows dans le PATH
if(Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"){
    if(-Not($path -match "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs")){
        Write-Host "On ne connait pas le PATH Windows start-up, ajout de tout les repertoires dans le PATH"
        [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\ProgramData\Microsoft\Windows\Start Menu\Programs", "User")
        $folder = Get-ChildItem -recurse "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" | % { $_.FullName }
        $folder | foreach-Object{
            if((Get-Item $_) -is [System.IO.fileinfo]){
                if($_ -match ".lnk"){
                    $name = $_.Split('\')[-1];
                    Copy-Item $_ -Destination "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\$name" -Force
                }
            }
        }
    }
}

#Ajout des raccourcis Start-up UTILISATEUR de Windows dans le PATH
$user = [Environment]::UserName
if(Test-Path "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs"){
    if(-Not($path -match "C:\\Users\\$user\\AppData\\Roaming\\Microsoft\\Windows\\Start Menu\\Programs")){
        Write-Host "On ne connait pas le PATH Utilisateur Windows start-up, ajout de tout les repertoires dans le PATH"
        [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs", "User")
        $folder = Get-ChildItem -recurse "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" | % { $_.FullName }
        $folder | foreach-Object{
            if((Get-Item $_) -is [System.IO.fileinfo]){
                if($_ -match ".lnk"){
                    $name = $_.Split('\')[-1];
                    Copy-Item $_ -Destination "C:\Users\$user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\$name" -Force
                }
            }
        }
    }
}

$argument = ' -command "cd '
$argument += "'"
$argument +=  $CWD
$argument += "'"
$argument += '; .\script_to_play.ps1"'

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $argument

$trigger =  New-ScheduledTaskTrigger -AtLogon -User $user

schtasks /delete /tn "Script de lancement" /f

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Script de lancement" -Description "Lancement des applications intéressantes"