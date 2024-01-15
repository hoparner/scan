#!/bin/bash

# VirusTotal API key
VT_API_KEY="783077f6a56582c67a28db7607780ca2b2ad7c1b2c5edcc988927ec71e7dc7a3"

# Function to check if a website is phishing
check_phishing() {
    result=$(curl -s -G --data-urlencode "url=$1" "https://api.phishtank.com/checkurl/<API_KEY>/")
    
    if [[ $result == *"\"valid\": false"* ]]; then
        echo -e "\033[0;31mPhishing site detected!\033[0m"  # Red color for phishing sites
    else
        echo -e "\033[0;32mNot a phishing site.\033[0m"  # Green color for clean sites
    fi
}

# Function to check for viruses in a website
check_viruses() {
    result=$(curl -s -F "file=@$1" "https://www.virustotal.com/api/v3/files" -H "x-apikey: $VT_API_KEY")
    
    if [[ $result == *"\"positives\": 0"* ]]; then
        echo -e "\033[0;32mNo viruses found.\033[0m"  # Green color for no viruses
    else
        echo -e "\033[0;31mViruses detected!\033[0m"  # Red color for viruses detected
        
        virus_name=$(echo $result | jq -r '.data.attributes.last_analysis_results[].result')
        echo -e "\033[0;31mVirus name(s): $virus_name\033[0m"
    fi
}

# Function to display the website status with colors
display_status() {
    if [[ $1 == "Phishing site detected!" ]]; then
        echo -e "\033[0;31m$1\033[0m"  # Red color for phishing sites
    elif [[ $1 == "No viruses found." ]]; then
        echo -e "\033[0;32m$1\033[0m"  # Green color for clean sites
    else
        echo -e "\033[0;31m$1\033[0m"  # Red color for viruses detected
    fi
}



echo_armenian_flag() {
    local text=$1
    local red="\033[0;31m"
    local blue="\033[0;34m"
    local orange="\033[0;33m"
    local reset="\033[0m"
    
    echo -e "by:${red}Leg${blue}ion${orange}_603${reset}"
}

# Main script
echo_armenian_flag "603"


# Main script
echo "Select the language:"
echo "1. Armenian"
echo "2. Russian"
echo "3. English"
read lang

case $lang in
    1)
        echo -e "\033[0;32mՄուտ քա գրեք կա յքի URL-ը:\033[0m"
        read url
        check_phishing $url
        check_viruses $url
        display_status "Ոչ մի վիրուս չի հա յտ նա բեր վել:"
        ;;
    2)
        echo -e "\033[0;32mВведите URL веб-сайта:\033[0m"
        read url
        check_phishing $url
        check_viruses $url
        display_status "Вирусов не обнаружено."
        ;;
    3)
        echo -e "\033[0;32mEnter the website URL:\033[0m"
        read url
        check_phishing $url
        check_viruses $url
        display_status "No viruses found."
        ;;
    *)
        echo "Invalid language selection."
        exit 1
        ;;
esac