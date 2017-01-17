$CWD = Convert-Path .

$path = $Env:Path;

#Ajout des raccourcis Start-up de Windows dans le PATH
if(Test-Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"){
    if(-Not($path -match "C:\\ProgramData\\Microsoft\\Windows\\Start Menu\\Programs")){
        Write-Host "On ne connait pas le PATH Windows start-up, ajout de tout les repertoires dans le PATH"
        [System.Environment]::SetEnvironmentVariable("PATH", $Env:Path + ";C:\ProgramData\Microsoft\Windows\Start Menu\Programs", "User")
        $folder = Get-ChildItem -recurse "C:\ProgramData\Microsoft\Windows\Start Menu\Programs" | % { $_.FullName }
        $folder | foreach-Object{
            if((Get-Item $_) -is [System.IO.DirectoryInfo]){
                $contournement = $_.replace('\','\\');
                if(-Not($path -match $contournement)){ 
                    $path += ";$_"
                    [System.Environment]::SetEnvironmentVariable("PATH", $path, "User")
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
            if((Get-Item $_) -is [System.IO.DirectoryInfo]){
                $contournement = $_.replace('\','\\');
                if(-Not($path -match $contournement)){
                    $path += ";$_"
                    [System.Environment]::SetEnvironmentVariable("PATH", $path, "User")
                }
            }
        }
    }
}


$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument " -WindowStyle Hidden -command '$CWD\script_to_play.ps1'"

$trigger =  New-ScheduledTaskTrigger -AtLogon -User $user

schtasks /delete /tn "Script de lancement" /f

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Script de lancement" -Description "Lancement des applications intéressantes"