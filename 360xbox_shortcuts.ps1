# Redirect all stdout and stderr to a log file
Start-Transcript -Path "$PSScriptRoot\360xbox_shortcuts.log" -Append
Write-Output "$(Get-Date)"

# Provide full path to roms here.
$content_path = "."

# CSV from: https://github.com/IronRingX/xbox360-gamelist
$file = "xbox360_gamelist.csv"
if (-Not (Test-Path $file)) {
    Invoke-WebRequest -Uri "https://github.com/IronRingX/xbox360-gamelist/raw/32aae7abeff7ed47969786309739444eb5397731/xbox360_gamelist.csv" -OutFile $file
}
Write-Output "`n`n"

# Find all directories matching the pattern and process each one
Get-ChildItem -Path $content_path -Recurse -Include "000d0000", "00007000" | ForEach-Object {
    $dir = Get-ChildItem -Path $_.FullName -File
    $title = ($dir -split '\\')[-3].ToUpper()

    Write-Output "Parsing: $title"
    Write-Output "Full Path: $dir"

    while ($true) { # Loop until we find the title ID
    # Parse the CSV file to find the matching game name and title ID
    $Header = 'Game_Name', 'Title_ID', 'Serial', 'Type', 'Region', 'XEX_CRC', 'Media_ID', 'Wave'
    Import-Csv -Path $file -Header $Header | ForEach-Object {
       
        if ($_.Title_ID -eq $title) {
            # Special case due to illegal characters in csv
            $Game_Name = $_.Game_Name -replace "[^a-zA-Z0-9.'! _()-]", ""
            $Game_Name = $Game_Name.Substring(0, [Math]::Min(244, $Game_Name.Length))
            $Type = ($_.Type).ToLower()

            Write-Output "Game Name: $Game_Name"
       
            Write-Output "Title ID: $title"
            if ($Type) {
                New-Item -ItemType Directory -Force -Path "$Type"
                $linkPath = ".\$Type\$Game_Name [$title]"
            } else {
                $linkPath = ".\$Game_Name [$title]"
            }
            Write-Output "Creating: $linkPath"
            New-Item -ItemType SymbolicLink -Path "$linkPath" -Target "$dir"

            Write-Output "`n`n"
            break
        } elseif ($Title_ID -eq "") {
            Write-Output "FAILED to process: $title at $dir"
            break
        }
    }
    }
}


