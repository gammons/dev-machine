#!/bin/bash

# UniFi Controller 5.8.28 auto installation script.
# Version  | 1.8
# Author   | Glenn Rietveld
# Email    | glennrietveld8@hotmail.nl
# Website  | https://GlennR.nl

if [ "$EUID" -ne 0 ]
  then
	clear
	echo "#####################################"
	echo -e "#  \e[91mPlease run this script as root.\e[0m  #"
	echo "#####################################"
  exit
fi

abort()
{
echo -e >&2 '
########################################
# \e[91mAn error occurred. Aborting script..\e[0m #
########################################
'
exit 1
}

trap 'abort' 0

set -e

clear
echo -e "\e[92m################################################\e[0m"
echo ""
echo " Getting the latest patches for your machine!"
echo " And installing needed packages!"
echo ""
echo -e "\e[92m################################################\e[0m"
echo ""
echo ""
sleep 3

sudo apt update; sudo apt upgrade -y; sudo apt dist-upgrade -y; sudo apt autoremove -y; sudo apt autoclean -y; sudo apt install -y software-properties-common; sudo apt install curl
sleep 1

clear

echo -e "\e[92m################################################\e[0m"
echo ""
echo " Updates successful."
echo " Now installing mongodb 3.4"
echo ""
echo -e "\e[92m################################################\e[0m"
echo ""
echo ""
sleep 3

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
codename=xenial
mongodb=3.4
wget -qO- https://www.mongodb.org/static/pgp/server-${mongodb}.asc | sudo apt-key add
apt update
apt install -y mongodb-org
sleep 1

clear

echo -e "\e[92m################################################\e[0m"
echo ""
echo " Mongodb 3.4 installation completed"
echo " Now installing java 8"
echo ""
echo -e "\e[92m################################################\e[0m"
echo ""
echo ""
sleep 3

add-apt-repository ppa:webupd8team/java -y
apt update
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
apt install oracle-java8-installer -y
apt install oracle-java8-set-default -y
echo "JAVA_HOME="/usr/lib/jvm/java-8-oracle"" >> /etc/environment
source /etc/environment
sleep 1

clear

echo -e "\e[92m################################################\e[0m"
echo ""
echo " Java 8 installation completed"
echo " Installing UniFi dependency"
echo ""
echo -e "\e[92m################################################\e[0m"
echo ""
echo ""
sleep 3

set +e

apt update
apt install jsvc libcommons-daemon-java -y

if [[ $? > 0 ]]
then
    clear
    echo -e "\e[92m################################################\e[0m"
    echo ""
    echo " Failed to install UniFi dependency, creating a backup of your sources.list!"
    echo " Adding lines to your source.list, so the installion will be successful"
	echo " Installing UniFi dependency"
    echo ""
    echo -e "\e[92m################################################\e[0m"
    echo ""
    echo ""
	sleep 2
	cp /etc/apt/sources.list /etc/apt/sources.list.glennrbackup
	echo deb http://nl.archive.ubuntu.com/ubuntu xenial main universe >>/etc/apt/sources.list
	apt update
	apt install jsvc libcommons-daemon-java -y
fi
sleep 1

set -e

clear

echo -e "\e[92m################################################\e[0m"
echo ""
echo " UniFi dependency installation completed"
echo " Now installing UniFi Controller 5.8.28"
echo ""
echo -e "\e[92m################################################\e[0m"
echo ""
echo ""
sleep 3

wget https://dl.ubnt.com/unifi/5.8.28/unifi_sysvinit_all.deb
DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical dpkg -i unifi_sysvinit_all.deb
rm ./unifi_sysvinit_all.deb
service unifi start
sleep 1

clear

if (whiptail --title "Ubiquiti Controller" --yesno "Do you want to be able to update the controller version using:\n\napt update && apt upgrade?\n\nNote: This only included updates in the 5.8 controller branch." 13 80) then
	clear
    echo -e "\e[92m################################################\e[0m"
	echo ""
	echo " Adding needed source entries for controller branche 5.8.x"
	echo ""
	echo -e "\e[92m################################################\e[0m"
	echo ""
	echo ""
	echo 'deb http://www.ubnt.com/downloads/unifi/debian unifi-5.8 ubiquiti' | sudo tee /etc/apt/sources.list.d/100-ubnt-unifi.list
	apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50
	apt-get update
	sleep 6
	clear
else
	clear
    echo -e "\e[92m################################################\e[0m"
	echo ""
	echo " You chose not to add the source files"
	echo " Finishing up the installation script!"
	echo ""
	echo -e "\e[92m################################################\e[0m"
	echo ""
	echo ""
	sleep 6
	clear
fi

if [ -f /etc/apt/sources.list.glennrbackup ]; then
if ! (whiptail --title "Ubiquiti Controller" --yesno "Do you want to restore the original sources.list?" 13 80) then
	clear
    echo -e "\e[92m################################################\e[0m"
	echo ""
	echo " You chose to keep the modified source files."
	echo " Finishing up the installation script."
	echo " Leaving a backup file of the sources.list so you can always revert back!"
	echo ""
	echo -e "\e[92m################################################\e[0m"
	echo ""
	echo ""
	sleep 5
	clear
else
	clear
    echo -e "\e[92m################################################\e[0m"
	echo ""
	echo " You chose to revert back to the original sources.list"
	echo " Changing the sources.list back to its original state!"
	echo ""
	echo -e "\e[92m################################################\e[0m"
	echo ""
	echo ""
	cp /etc/apt/sources.list.glennrbackup /etc/apt/sources.list
	rm /etc/apt/sources.list.glennrbackup
	sleep 5
	clear
fi
fi

trap : 0

exit 0
