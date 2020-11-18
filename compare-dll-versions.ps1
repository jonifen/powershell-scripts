# Script to compare the versions of DLLs within 2 directories.
# Output is in a CSV format which can be viewed in Excel etc.

# Specify the two directories to scan below
$directoryA = ""
$directoryB = ""
# -----

Function Get-FileVersionDifferences($dirA, $dirB) {
    $files = Get-ChildItem $dirA -Filter *.dll

    Write-Output "File Name,Directory A,Directory B"
    foreach ($file in $files) {
        $aFileVersion = (Get-Command $file.FullName).FileVersionInfo.FileVersion
        $bFilePath = "$($dirB)\$($file.Name)"

        if ((Test-Path $bFilePath) -eq $false) {
            Write-Output "$($file.Name),$($aFileVersion),N/A"
        }
        else
        {
            try {
                $fileB = Get-ChildItem $bFilePath
                $bFileVersion = (Get-Command $fileB.FullName).FileVersionInfo.FileVersion

                if (-not ($aFileVersion -eq $bFileVersion)) {
                    Write-Output "$($file.Name),$($aFileVersion),$($bFileVersion)"
                }
            }
            catch {
                Write-Output "$($file.Name),$($aFileVersion),N/A"
            }
        }
    }
}

# Check the differences in both directions
Get-FileVersionDifferences $directoryA $directoryB
Write-Output ""
Get-FileVersionDifferences $directoryB $directoryA
