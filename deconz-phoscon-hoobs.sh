#!/bin/bash

echo "----------------------------------------------------------------"
echo "This will install DeConz and Phoscon for HOOBS 3"
echo "----------------------------------------------------------------"

echo "----------------------------------------------------------------"
echo "After the installation is completed the Device performs an"
echo "reboot and you can access Phoscon and HOOBS as following:"
echo "----------------------------------------------------------------"
echo "Phoscon Interface is reachable at hoobs.local"
echo "HOOBS   Interface is reachable at hoobs.local:8080"
echo "----------------------------------------------------------------"
while true; do
    read -p "Do you wish to install?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo "Enable Raspberry Serial Port.."
yes y | sudo raspi-config nonint do_serial 1
echo "Raspberry Serial Port enabled"
echo "----------------------------------------------------------------"
echo "Get Phoscon Public Key....."
yes y | wget -O - http://phoscon.de/apt/deconz.pub.key | \
yes y | sudo apt-key add -
echo "Installing....."
yes y | sudo sh -c "echo 'deb http://phoscon.de/apt/deconz \
            $(lsb_release -cs) main' > \
            /etc/apt/sources.list.d/deconz.list"
yes y | sudo apt update
yes y | sudo apt install deconz
echo "DeConz & Phoscon installed."
echo "----------------------------------------------------------------"
echo "Installing Wiring Pi (for Rpi4B)....."
yes y | cd /tmp
yes y | wget https://project-downloads.drogon.net/wiringpi-latest.deb
yes y | sudo dpkg -i wiringpi-latest.deb
echo "Wiring Pi (for Rpi4B) installed"
echo "----------------------------------------------------------------"
echo "Updating DeConz"
yes y | wget https://www.dresden-elektronik.de/rpi/deconz/deconz-latest.deb
sudo dpkg -i deconz-latest.deb
echo "DeConz updated"
echo "----------------------------------------------------------------"
echo "Disable GUI for DeConz...."
yes y | sudo systemctl disable deconz-gui.service
yes y | sudo systemctl disable nginx.service
echo "GUI for DeConz disabled"
echo "----------------------------------------------------------------"
echo "Rebooting now....."
echo "----------------------------------------------------------------"
wait 10
sudo reboot

