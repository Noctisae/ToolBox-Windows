param([String]$directory_to_scan="E:\Hash",
    [String]$fichier_for_all_hash="hashs.txt",
    [String]$hash_of_all_hash="final_hash.txt")
Remove-Item "$directory_to_scan\$fichier_for_all_hash" -ErrorAction SilentlyContinue
Remove-Item "$directory_to_scan\$hash_of_all_hash" -ErrorAction SilentlyContinue
$files = Get-ChildItem -recurse $directory_to_scan -File | % { $_.FullName }
New-Item "$directory_to_scan\$fichier_for_all_hash" -type file -Force | Out-Null
New-Item "$directory_to_scan\$hash_of_all_hash" -type file -Force | Out-Null
ForEach($file in $files){
    $hash = ./md5.exe $file
    Set-Content "$directory_to_scan\$fichier_for_all_hash" ((Get-Content "$directory_to_scan\$fichier_for_all_hash") + [Environment]::NewLine + $hash )
}
(Get-Content "$directory_to_scan\$fichier_for_all_hash") | ? {$_.trim() -ne "" } | Set-content "$directory_to_scan\$fichier_for_all_hash"
$hash = ./md5.exe -n "$directory_to_scan\$fichier_for_all_hash"
Set-Content "$directory_to_scan\$hash_of_all_hash" $hash
Write-Host "MD5 Hashing complete"