#!/bin/bash

dpn=("wget" "unzip" "curl" "jq")
jdkurl="https://cdn.azul.com/zulu/bin/zulu8.72.0.17-ca-fx-jdk8.0.382-win_x64.zip"
jdkzip="$(pwd)/$(basename "$jdkurl")"
jdkfp=${jdkzip//".zip"/}

wineurl=$(curl -s -q https://api.github.com/repos/GloriousEggroll/wine-ge-custom/releases/latest | jq -r '.assets[] | select(.name | test("x86_64.tar.xz$")) | .browser_download_url')
winetar="$(pwd)/$(basename "$wineurl")"
winefp=${winetar//"wine-"/}; winefp=${winefp//".tar.xz"/}

echo "Drip Lite Installer"
sleep 1

echo "Checking for required dependencies..."

for dependency in "${dpn[@]}"; do
    if ! command -v "$dependency" &> /dev/null; then
        echo "$dependency is not installed!"
        exit 1
    fi
done
sleep 3

echo "You need to download a portable Minecraft Launcher (for Windows) before running this script!"
echo "If you have one, please move it to THIS folder!"
echo "Do you have a portable Launcher installed, on this folder, ready to go? y/n"
read -r Launcher
if [[ ! $Launcher ]]; then
    echo "Please provide an answer!"
    exit 1
fi
Launcher="${Launcher,,}"
if [[ $Launcher != "y" && $Launcher != "yes" ]]; then
    echo "Install a Launcher first!"
    exit 1
else
    echo "Please provide the location of the Launcher from this directory."
    read -r LauncherLoc
    if [[ ! $LauncherLoc ]]; then
        echo "Please provide a location!"
        exit 1
    else
        echo "Set Launcher location to $(pwd)/$LauncherLoc."
    fi
fi
sleep 3

echo "You must have Drip Lite already installed before running this script!"
echo "If you already have Drip Lite installed, on this folder, and ready to go, please enter the name of the executable."
read -r DripExec
if [[ ! $DripExec ]]; then
    echo "Please enter the name of the executable!"
    exit 1
fi
sleep 3

echo "Downloading WineGE..."
wget -nv "$wineurl" &> /dev/null
sleep 3

echo "Unpacking WineGE..."
tar -xf "$winetar" &> /dev/null
rm "$winetar"
sleep 3

echo "Making Drip Lite script..."
echo "$winefp/bin/wine $(pwd)/$DripExec" > Drip.sh
chmod +x Drip.sh
sleep 1

echo "Making Launcher script..."
echo "$winefp/bin/wine $(pwd)/$LauncherLoc" > Launcher.sh
chmod +x Launcher.sh
sleep 1

echo "All done!"
