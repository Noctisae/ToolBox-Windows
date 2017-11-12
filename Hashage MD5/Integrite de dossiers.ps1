param([String] $mode="list",
    [String]$directory_to_scan="E:\Hash",
    [String]$fichier_for_all_hash="hashs.txt",
    [String]$hash_of_all_hash="final_hash.txt")






Function ListAllFilesAndCreateHash{
    param([String]$directory_to_scan=".")
    $result = @{}
    $files = Get-ChildItem -recurse $directory_to_scan -File -Exclude *.param | % { $_.FullName }
    ForEach($file in $files){
        $hash = ./md5.exe $file
        $result.["$file"] = $hash
    }
    return result
}

Function retrieveFilesAndHash{
    param([String]$file_containing_hash=".")
    $result = @{}
    $a = Get-Content $file_containing_hash
    ForEach($line in $a){
        $temp = $line.Split("|")
        $result["$temp[0]"] = $temp[1]
    }
    return result
}

Function CreateHashFilesAndHashIt{
    param([String]$folder_to_hash="E:\Hash",
    [String]$fichier_for_all_hash="hashs.txt",
    [String]$hash_of_all_hash="final_hash.txt")
    Remove-Item "$directory_to_scan\$fichier_for_all_hash" -ErrorAction SilentlyContinue
    Remove-Item "$directory_to_scan\$hash_of_all_hash" -ErrorAction SilentlyContinue
    New-Item "$directory_to_scan\$fichier_for_all_hash" -type file -Force | Out-Null
    New-Item "$directory_to_scan\$hash_of_all_hash" -type file -Force | Out-Null
    ForEach($result in $folder_to_hash.Keys){
        Set-Content "$directory_to_scan\$fichier_for_all_hash" ((Get-Content "$directory_to_scan\$fichier_for_all_hash") + [Environment]::NewLine + "$result|$folder_to_hash[$result]" )
    }
    (Get-Content "$directory_to_scan\$fichier_for_all_hash") | ? {$_.trim() -ne "" } | Set-content "$directory_to_scan\$fichier_for_all_hash"
    $hash = ./md5.exe -n "$directory_to_scan\$fichier_for_all_hash"
    Set-Content "$directory_to_scan\$hash_of_all_hash" $hash
    Write-Host "MD5 Hashing complete"
}


try{
    $modelower = "$mode".ToLower()
    $actual_folder = ListAllFilesAndCreateHash -directory_to_scan $directory_to_scan
    if($modelower -match "list"){
        CreateHashFilesAndHashIt -folder_to_hash $actual_folder -fichier_for_all_hash "./hashs.txt" -hash_of_all_hash "./final_hash.txt"
    }
    else{
        $saved_folder = retrieveFilesAndHash -file_containing_hash "./hashs.txt"
        $saved_folder | Where {$actual_folder -NotContains $_}
    }
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host $ErrorMessage
}







Workflow:
    Deux modes:
        List ==> Création de la liste, des hashs de chaque fichier et ecriture dans fichier a côté
        Compare ==> Récupération de la liste, création de la liste actuelle, puis comparaison entre les deux et sortie des differences