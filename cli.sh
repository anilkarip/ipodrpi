#!/bin/bash

#screen

echo -e "\e[1;36m NOW INSTALL pikeyd \e[0m"
cd ~
sudo cp ~/ipodrpi/etc/pikeyd.conf /etc/pikeyd.conf
git clone git://github.com/mmoller2k/pikeyd
make -C pikeyd
sudo cp pikeyd/pikeyd /usr/local/bin/
sudo sed -i -e '$ i\/usr/local/bin/pikeyd -d' /etc/rc.local
echo -e "\e[1;36m pikeyd INSTALLED AS DAEMON (/etc/rc.local METHOD) \e[0m"

echo -e "\e[1;36m NOW INSTALLING pigpio \e[0m"
sudo apt-get install -y python3-distutils
cd ~
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
sudo make install

echo -e "\e[1;36m NOW INSTALLING click.c \e[0m"
cd ~
git clone https://github.com/WiringPi/WiringPi
cd ~/WiringPi/
./build
cd ~/ipodrpi
gcc -Wall -pthread -o click click.c -lpigpio -lrt -lwiringPi
sudo chmod +x click
sudo cp ~/ipodrpi/click /usr/local/bin/click
sudo cp ~/ipodrpi/system/click.sh /usr/local/bin/click.sh
sudo chmod +x /usr/local/bin/click.sh
sudo sed -i -e '$ i\/usr/local/bin/click.sh' /etc/rc.local


read -r -p "CHANGE CONSOLE FONT TO BIGGER ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
sudo cp ~/ipodrpi/system/console-setup /etc/default/console-setup
sudo /etc/init.d/console-setup.sh restart
else
echo Skipping..
fi

read -r -p "ncmpcpp ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo -e "\e[1;36m OK, ncmpcpp WILL START AT BOOT \e[0m"
sudo apt-get install -y mpd mpc ncmpcpp
sudo rm /etc/mpd.conf
sudo cp ~/ipodrpi/etc/mpd.conf /etc/mpd.conf
sudo mkdir ~/Music
sudo mkdir ~/Music/playlists
sudo ln -s ~/Music /var/lib/mpd/Music
#sudo ln -s ~/Music/playlists /var/lib/mpd/Music/playlists
mpc update
sudo rm /etc/pikeyd.conf
sudo cp ~/ipodrpi/etc/pikeyd.conf.ncmpcpp /etc/pikeyd.conf
echo "mpc update" >> ~/.bashrc
echo "ncmpcpp" >> ~/.bashrc
else
echo Skipping..
fi

read -r -p "TUNE VOLUME IN ALSAMIXER ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo -e "\e[1;36m UP/DOWN arrow keys to tune volume, ESC to exit \e[0m"
alsamixer
else
echo Skipping..
fi


read -r -p " VNC (DISPMANX) ?[y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo -e "\e[1;36m OK \e[0m"
sudo apt-get install libvncserver-dev
cd
git clone https://github.com/hanzelpeter/dispmanx_vnc
cd dispmanx_vnc
make
sudo ./dispmanx_vncserver
else
echo Skipping..
fi


read -r -p "CLEANUP ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo -e "\e[1;36m OK, CLEANING ~ \e[0m"
sudo rm -r ~/ipodrpi
sudo rm -r ~/pigpio-master
sudo rm -r waveshare_fbcp-main
sudo rm -r WiringPi
sudo rm pikeyd
sudo rm Waveshare_fbcp-main.7z
else
echo Skipping..
fi

echo -e "\e[1;36m DONE. PLEASE REBOOT NOW \e[0m"
read -r -p "REBOOT ? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
echo -e "\e[1;36m OK, REBOOTING  \e[0m"
sudo reboot now
else
echo Skipping..
fi
