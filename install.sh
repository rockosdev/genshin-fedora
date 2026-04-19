#!/bin/bash

NAME="genshin-fedora"
DIR="/usr/share/sddm/themes/$NAME/"
CFG="/etc/sddm.conf"

cd "$(dirname "$0")"

function displayArtAndWelcome {

    BLUE="\033[34m"
    RESET="\033[0m"
    echo -e "run"
    echo -e "${BLUE}"

echo "⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⢫⢅⣫⣾⣟⣿⣦⣝⣻⣯⠵⠛⠛⠛⠻⠿⣟⡿⣶⣅⡚⢭⡙⠿⢿⣿⣿⣿⣿⣿⣿⣿⣯⡻⢿⣿⣿⣿⣿⣿⣿⣿⣽⡽⣿⣿⣿"
echo "⠂⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⠟⡌⣣⣾⣿⠷⢛⠉⢀⡼⡃⠀⠀⠀⠀⠀⠒⠤⣀⠙⠻⣾⣻⡳⣌⢇⡢⢍⡛⢿⣿⣿⣿⣿⣿⣿⣷⡹⣿⣿⣿⣿⣿⣿⣿⣿⣝⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⡽⣱⢋⣼⡿⢋⠁⣰⠃⢀⡿⢹⠀⠀⠀⡀⠀⠀⠀⠀⠈⠓⢦⡈⠻⣽⣮⡢⠉⠲⢍⠒⡹⣿⣿⣿⣿⣿⣿⣿⣷⡽⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣜⠞⡼⡁⣾⠋⡀⠆⣼⢡⠂⣼⠃⠋⠀⠀⠀⢡⠀⠀⠀⠀⠀⠀⠀⠙⠲⣄⠙⢷⡄⠀⠀⠀⠑⠽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⠋⡼⣐⣥⡇⢁⢂⣴⡇⠇⠀⠃⠀⢁⠀⠀⠀⠀⢆⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⡌⠻⣆⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣿⡿⣛⠿⣽"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⠃⡴⢣⠎⡼⠀⢠⢯⢿⠀⠀⠀⠀⠀⡈⡄⠀⠀⠀⠈⢧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢦⡙⣧⠀⢀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣽⣯⣷⣶⣾⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⡏⢰⠃⡱⢺⠇⠀⡟⢸⡃⠀⠀⠀⠀⠀⢤⠰⡄⠀⠀⠀⠀⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣌⢷⡈⢆⠀⠈⢆⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⢠⣳⢠⢣⠎⠀⡜⠀⡜⡀⡧⡇⠀⠀⠀⠀⠀⠘⣄⠑⣄⠀⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢮⣧⠀⠣⠀⠈⢧⢈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⣜⠃⡜⠁⠀⠀⡇⢰⠱⠀⡇⡇⠀⠀⠀⠀⡆⠀⠘⣆⠈⢢⡀⠀⠀⠀⠈⠛⢦⡀⠀⠀⠀⠀⠀⠀⢀⠈⢿⣧⠀⠀⠀⠈⢣⠒⡈⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⢀⡾⡜⠀⠀⡀⠀⢰⢀⡎⠁⠀⢧⠃⡀⢀⠀⠀⢱⠀⠀⠈⢧⡀⠘⠢⡀⠀⠀⠀⠀⠙⠲⣤⣀⠀⠀⠀⠀⠳⠌⢿⣧⢆⠀⠀⠈⢷⠈⡔⠙⣿⣿⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⢀⣀⡤⠒⢙⣧⢃⠃⠀⠀⢀⡟⡜⠀⠀⠀⢸⡇⠑⠀⠡⡀⠀⢣⠀⠀⠀⠙⢆⡁⠌⠓⢄⡀⠀⠀⠀⠀⠉⠛⠶⣦⣤⣀⣈⣢⠻⣧⠣⡀⠀⠈⢣⡐⠡⠌⢻⣿⣿⣿⣿⣿⣿"
echo "⠀⠀⠀⠈⠉⠉⠉⡟⡘⠀⡀⠀⣼⢡⠃⠀⠀⠀⢨⣇⠀⠀⠀⠑⢄⠈⢆⠀⠀⠀⠀⠙⠢⣄⠀⠈⠑⠢⢄⣀⠀⠀⠀⠀⠈⠉⠓⠫⠽⠭⢷⣛⣖⣶⣒⣟⣲⣘⣦⠽⢛⣽⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⠀⡇⡇⠀⠁⣸⢇⠎⠀⠀⠀⠀⢸⢹⡀⠀⠀⠀⠀⠑⢜⡧⡀⠀⠀⠀⠀⠀⠉⠒⠤⣀⠀⠀⠈⠉⠒⠠⠤⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡔⢋⠻⣿⣿⣿"
echo "⠀⠀⠀⠀⠀⠀⢰⠘⠀⢀⠜⢉⠎⠀⠀⠀⠀⠎⡇⠀⢣⠀⠀⠀⠀⠀⠀⠹⡍⠢⡘⢍⠉⡉⠉⠉⠑⠚⢝⡚⠥⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢉⡵⠚⢆⠂⢄⡈⢿⣿"
echo "⠀⠀⠀⠀⠀⠀⡼⡡⢔⠁⢠⠋⠀⠀⠀⡠⠊⡼⠀⠀⣠⣧⡀⠀⠀⠀⠀⠀⠱⠘⡌⠐⠌⡈⠐⠄⠀⠀⠈⠈⠢⣀⠈⠉⠒⠲⠤⠄⣀⣀⣀⣀⣀⣤⣴⣞⠑⢄⠀⠈⠣⣀⠘⢢⡙"
echo "⠀⠀⠀⢄⠀⢀⠃⠀⣀⠔⠁⠀⣀⣤⠞⠁⢰⢁⡴⠞⠋⠀⠑⠄⠀⠀⠀⠀⠀⠳⣥⠀⠀⠀⠁⠂⢄⡀⠀⠀⠀⠀⠙⠶⣦⠤⠤⡤⢤⢤⣴⣖⠛⠻⢿⣿⣷⣤⡑⢄⠀⠈⠓⢄⠘"
echo "⠀⠀⠀⠣⡉⠨⠔⢈⣀⣤⠲⠝⠊⠀⢁⢄⠞⠉⠀⠀⠀⠀⠀⠈⠢⡀⡀⠀⠀⠀⠹⡇⠀⡠⣒⣭⡶⢖⣻⣶⣤⣀⡀⠀⠈⠙⠻⠝⢋⣉⠀⠈⠙⠓⡦⢭⡻⢿⡿⣾⣷⣄⡀⠀⠑"
echo "⠀⠀⠀⠀⠜⢩⣉⣉⣁⣀⣀⡠⠄⠒⢁⡞⢀⣄⠀⠀⢀⣀⣀⡀⠀⠀⢈⠢⡀⠀⠀⠘⢆⠰⣿⠟⠋⠉⠀⠀⠀⠈⠉⠙⠒⡒⠶⢖⠒⠒⠋⠀⠀⠀⠈⠁⠋⠓⢽⣳⣯⢟⡿⣶⣄"
echo "⠀⠀⠀⢊⠔⠉⡰⢡⠠⠐⠈⠀⠀⣠⣿⢧⡀⢑⡬⢵⠶⢦⣤⣈⠆⠀⠀⠀⠨⡂⡀⠀⠈⠢⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⢀⠈⠢⣀⠀⠀⠀⠀⠀⠀⠀⢄⡈⠺⣿⡼⣣⣟"
echo "⠀⠀⡠⠓⠁⣸⠁⡘⠁⠀⠀⠀⡔⠁⣼⡄⣹⣉⣤⠞⠉⠉⠉⠉⠁⠀⠀⠀⠀⠈⠀⢄⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡄⠉⣲⠤⣅⣂⣀⠀⠀⠀⠀⠀⠈⠲⣌⢿⣵⢺"
echo "⠀⠀⠁⠀⠀⡇⡔⡇⠀⠀⢀⠼⡄⠀⢹⡝⡍⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠐⠠⢀⡈⠂⢀⠀⠀⠀⠀⠀⠀⠀⢠⠃⠚⢹⢣⡀⠙⢝⠻⢿⣒⢶⣶⣶⣤⣌⣻⡾⣝"
echo "⠀⠀⠣⡀⠀⡶⠀⡇⠀⠀⡎⠄⢳⠀⠀⢷⠘⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠁⠀⠀⠀⠀⠀⣐⣿⣴⣶⠇⠀⣿⡄⠀⠳⡀⠙⢮⣿⣾⢫⢞⣽⡿⠈"
echo "⠀⠀⠀⠈⠂⡇⡠⢇⠀⢸⠀⠠⠀⣳⡀⠈⢦⠈⠆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣼⡟⣼⠏⢀⣼⡿⡟⣄⠀⠹⡄⢺⡿⣣⠻⣜⡾⠀⠀"
echo "⠀⠀⠀⠀⠀⢣⢡⠈⠆⢯⠀⠀⡼⠁⢝⠢⢄⡓⢜⣆⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠄⠂⠐⠒⠒⡶⠀⠀⠀⠀⠀⠀⠀⢀⣾⡿⣯⣥⣶⢿⣻⠷⡹⣌⢆⠀⡷⢸⡷⣭⠗⠋⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠑⢄⠈⠘⢤⡜⠁⠀⠀⠑⡐⠌⠛⢽⣦⠀⠀⠀⠀⠀⠀⠘⠣⠄⣀⣀⡀⠄⠊⠀⠀⠀⠀⠀⠀⠀⣠⣿⢯⣳⣛⡞⣱⡿⣭⢳⡱⢜⡸⢀⣧⣿⣷⠋⠀⠀⠄⠁⠂"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠑⠠⢀⠙⡐⡢⠤⠀⣘⠈⠆⠀⠙⢷⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠺⣿⡹⢮⢵⡏⡼⣻⣵⢫⡖⣭⠚⣤⠟⢹⡜⢇⠀⠀⠀⢀⠈⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢡⢃⠁⠀⢀⠎⡇⠘⠀⠀⠈⣧⠹⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡴⠚⢂⠡⣿⡹⣏⣾⠀⠐⢍⠳⠯⣾⣖⡋⠁⠀⠈⠣⣄⣙⡲⠞⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⡠⠊⡀⠃⠀⠀⠀⠀⡼⢳⢊⡝⢫⠟⣶⣤⣀⠀⠀⠀⣀⠤⠚⠁⠐⠈⣀⠰⣷⡏⠉⠈⣇⠀⠀⠩⡀⠀⢀⡈⠑⠦⡀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣅⠄⠊⠀⠀⠀⠀⢀⠔⢀⠏⠴⣈⣃⢎⣿⢿⠿⣿⣶⣮⣅⡀⠀⠀⠀⠀⢁⣴⣿⡇⠀⠀⠙⣆⠀⠀⠐⡀⠀⠈⠑⠢⣹⡆⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⠀⢀⡼⡙⢦⢣⢻⠀⠀⠀⢀⢤⠮⣐⡠⠮⢼⣒⣭⠷⣯⣿⠋⠀⠈⢷⣻⣞⡽⡿⣶⣴⣴⣿⡿⣿⠹⣄⠀⠀⠀⠑⠒⠤⠈⣂⣀⣀⠀⠈⣷⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⠀⢠⡫⣫⠓⠮⣆⡹⢄⠀⢠⢧⡖⣋⠳⣌⢻⣯⣝⢮⣛⣧⣛⢯⡟⣶⣄⢻⣼⣽⣳⣽⡄⢸⣿⢷⡿⠀⠌⣢⠀⠀⠀⠀⠀⢰⠣⡀⣀⠗⠑⣽⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⠀⢠⠟⣱⠃⠀⠠⢀⠙⢦⡓⢬⣙⣃⣥⠃⠈⡥⣱⣻⠉⠉⠉⠉⠉⠉⠉⠉⠉⣿⡍⣉⣨⣽⠖⡻⢷⣦⣀⣾⣷⡶⢶⢦⡤⣤⡤⣵⣍⣓⣦⡤⠊⠀⠀⠀⠀⠀⠀⠁"
echo "⠀⠀⠀⠀⠀⠀⡾⢡⠇⠀⠀⠀⠀⠀⠀⠙⣆⣿⣫⡐⠝⡢⣄⠐⢳⢣⠀⠀⠀⠀⠒⠊⣡⡴⣏⢿⡹⢧⣿⠀⡟⡗⠮⢟⣿⣼⣛⢯⡟⡾⣥⢯⣖⣩⣻⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀"
echo "⠀⠀⠀⠀⠀⢰⠁⡞⠀⠀⠀⠀⠀⠀⠀⠀⠈⢳⠈⠛⠵⣬⡐⠵⡈⢯⢐⠠⢄⣠⢴⣾⠋⠀⠘⡮⣝⡲⡽⢀⣇⡹⣄⡷⠉⡽⣜⠶⣩⢷⡹⢧⡚⡴⡹⣍⢷⡀⠀⠀⠀⠀⠀⠀⠀"
echo "⣶⣶⣶⣶⣶⣾⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⣠⢾⠀⠀⠀⢱⠈⢓⢬⡽⢂⠖⠋⢀⠜⠁⠀⠀⠀⢹⡔⢣⢻⠸⢇⠈⠙⠅⠀⡇⠸⢯⣣⢏⡼⢣⠟⣜⡱⢊⡧⢿⡄⠀⠀⠀⠀⠀⠀"
echo "⣿⣞⣷⣿⣿⣯⡻⣄⠀⠀⠀⠀⠀⠀⣠⠔⢁⠼⡇⠀⠀⠘⡀⠘⡄⠙⡷⡄⠐⢡⠤⠤⠤⢄⡀⢸⠨⢱⠘⣆⠪⢆⡀⠀⠀⠰⡀⢸⡅⢺⡜⣣⠙⡴⣉⢏⡞⣥⠻⠀⠀⠀⠀⠀⠀"
echo "⣿⣿⣿⣿⣿⣿⣿⣮⡛⣤⣀⣀⡠⣊⠤⠂⠀⠀⢹⠀⠀⠀⢇⠀⢣⠀⠘⠌⠒⠤⡷⠁⠀⠀⠎⠁⠄⠃⠜⠀⠳⢌⠻⠆⠤⠤⠌⢀⠇⠣⡔⠣⢙⠲⢤⠣⠜⢢⠛⠆⠀⠀⠀⠀"


    echo -e "${RESET}Welcome Traveler. Thank you for downloading genshin-fedora."
    echo "Please press any button to continue."
    read -n 1 -s -r
}

function selectOS {
    echo "Choose your operating system:"
    select os in "Debian Based" "Arch Based" "Fedora"; do
        case $os in
            "Debian Based"|"Arch Based"|"Fedora" ) installPackages "$os"; break;;
            * ) echo "Invalid selection. Please try again.";;
        esac
    done
}

function installPackages {
    case $1 in
        "Debian Based" )
            sudo apt-get install qt6-base-dev qml6-module-qtmultimedia qt6-multimedia-dev gstreamer1.0-plugins-good gstreamer1.0-libav
            ;;
        "Arch Based" )
            sudo pacman -S --needed qt6-base qt6-multimedia qt6-5compat gst-libav gst-plugins-base gst-plugins-good --overwrite '*'
            ;;
        "Fedora" )
            sudo dnf install qt6-qtbase qt6-qtmultimedia qt6-qtquickcontrols2 gstreamer1-plugins-good gstreamer1-libav
            ;;
        * )
            echo "Error: Invalid OS option"
            ;;
    esac
}

function changeCurrentTheme {
    if grep -q "^\[Theme\]" $CFG; then
        if grep -q "^Current=" $CFG; then
            sudo sed -i "s/^Current=.*/Current=$NAME/" $CFG
        else
            sudo sed -i "/^\[Theme\]/a Current=$NAME" $CFG
        fi
    else
        echo -e "\n[Theme]\nCurrent=$NAME" | sudo tee -a $CFG > /dev/null
    fi
    echo "Current theme changed to $NAME"
}

function disableVirtualKeyboard {
    if ! grep -wq "InputMethod=" $CFG; then
        echo -e "\nDo you want to disable the virtual on-screen keyboard in SDDM? Select yes if you have a physical keyboard"
        select sel in "Yes" "No"; do
            case $sel in
                Yes )
                if grep -q "^InputMethod=qtvirtualkeyboard" $CFG; then
                    sudo sed -i "s/^InputMethod=qtvirtualkeyboard/InputMethod=/" $CFG;
                    echo "Virtual keyboard disabled (modified InputMethod entry)";
                elif ! grep -q "^InputMethod=" $CFG; then
                    sudo sed -i 's/^\[General\]/\[General\]\nInputMethod=/' $CFG;
                    echo "Virtual keyboard disabled (created empty InputMethod entry)";
                fi
                break;;
                No ) break;;
            esac
        done
    fi
}

function testTheme {
    echo -e "\nDo you want to test the theme now?"
    select sel in "Yes" "No"; do
        case $sel in
            Yes ) sddm-greeter --test-mode --theme $DIR; break;;
            No ) exit;;
        esac
    done
}

function createConfig {
    sddm --example-config | sudo tee $CFG > /dev/null
    echo "Configuration file created in $CFG"
}

function installThemeFiles {
    echo "Installing theme to $DIR..."
    if [ -d "$DIR" ]; then
        sudo rm -rf "$DIR"
    fi
    sudo mkdir -p "$DIR"
    sudo rsync -a --exclude='install.sh' --exclude='.git' . "$DIR"
}

function mainOperations {
    if [ ! -f $CFG ]; then
        echo -e "\nSDDM configuration file $CFG does not exist. Do you want to create it based on current configuration?"
        select sel in "Yes" "No"; do
            case $sel in
                Yes )
                    createConfig
                    changeCurrentTheme
                    selectOS
                    installThemeFiles
                    disableVirtualKeyboard
                    testTheme
                    break
                    ;;
                No )
                    echo "Theme will be installed in $DIR but configuration not changed."
                    installThemeFiles
                    testTheme
                    break
                    ;;
            esac
        done
    else
        selectOS
        installThemeFiles
        changeCurrentTheme
        disableVirtualKeyboard
        testTheme
    fi
}

displayArtAndWelcome

mainOperations
