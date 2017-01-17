param([String]$directory_to_scan="E:\Convert",
    [String]$extension_to_convert="avi",
    [String]$extension_to_convert_to="webm",
    [String]$quality="good",
    [Int32]$cpu_used=3,
    [String]$deadline="realtime",
    [Int32]$resolution=1080,
    [Int32]$threads=3)

try{
    $files = Get-ChildItem -recurse $directory_to_scan -File -include "*.$extension_to_convert" -exclude "*.$extension_to_convert_to" | % { $_.FullName }
    if($files){
        ForEach ($video in $files) {

            $sortie = $video -replace $extension_to_convert,$extension_to_convert_to;

            $ArgumentList = '-i "{0}" -y -codec:v libvpx -quality {1} -cpu-used {2} -deadline {3} -vf scale=-1:{4} -threads {5} -codec:a libvorbis -b:a 128k "{6}"' -f $video, $quality, $cpu_used, $deadline, $resolution, $threads, $sortie;
            Write-Host -ForegroundColor Green -Object $ArgumentList;
            #Write-Host $video
            $process = start-process -FilePath "./ffmpeg.exe" -ArgumentList $ArgumentList -PassThru -Wait
            if($process.ExitCode -eq 0){
                Write-Host "Successfully converted $video to $extension_to_convert_to"
            }
            else{
                Write-Host "Something has gone wrong : here's the program exit Code "
                Write-Host $process.ExitCode
            }
        }
    }
    else{
        Write-Host "no file to convert found, exiting...."
        exit 0
    }
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host $ErrorMessage
}
