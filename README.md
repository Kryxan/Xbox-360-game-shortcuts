# Xbox-360-game-shortcuts  
Simple Windows and Linux scripts to make symbolic links to your 360 games for the purpose of emulation. This is created for those who wish maintain their directory structure, and do not want to rename files. If you do not have original hardware and have no desire to maintain the original file structure then you can use other scripts to rename your files.  

The .sh file is a Bash script for Linux systems.  
The .ps1 file is a PowerShell script for Windows systems.  
They each should produce similar results, though I have only run the PowerShell script in a test environment whereas the Bash script was run on my gaming system.  
  
  
  
  
## How to:  
  
Step 1: download the appropriate script to your 360 roms folder (eg \Emulation\Roms\xbox360\roms\)  

Step 2: place a symlink for your Content folder in the rom folder OR edit the script to point to you Content folder   

Step 3: execute the script to output symlinks for all your XBox 360 games (you can now delete the content symlink)  

Step 4: launch EmulationStation or Steam Rom Manager and parse your games  

Step 5: play the game (assuming game is compatible with the current release)  
  
  
> [!IMPORTANT]
> Assumes XBox 360 games are stored in the /content/ folder, as they would be if transferred from your XBox, and are stored in GOD format.
  
  
### How the XBox 360 stores games:   
````
Content   
 0000000000000000   
  454107DC      -- Xbox360 game Title ID   
    00000002    -- Xbox360 game DLC   
    00070000    -- XBox360 game in GOD format   
  4541080F   
  584113BF      -- Xbox360 game Title ID   
    000D0000    -- XBox360 Live Arcade game   
  ...other titles   
````  
   
  
  
  
> [!WARNING]
> ### known bugs and issues:
> - this script does not know how to handle multidisc games. It will create only one symlink. If you have multidisc games, you should determine which disc is the play disc and remove the others, replace the other disc files after running the script.
  
  
  
  
 ### Please also consult:
  
This script will download a CSV file to process game Title ID's to retreive the Game Name.   
https://github.com/IronRingX/xbox360-gamelist

The Xenia project page   
https://github.com/xenia-canary/xenia-canary

The Xenia wiki   
https://github.com/xenia-canary/xenia-canary/wiki

The Emudeck wiki for Xbox 360   
https://emudeck.github.io/emulators/steamos/xenia/

The Emulation Station userguide   
https://gitlab.com/es-de/emulationstation-de/-/blob/master/USERGUIDE.md#microsoft-xbox-360



