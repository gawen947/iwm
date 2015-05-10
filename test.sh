set -x

sudo kldunload if_iwm iwm-7265-9
set -e
make cleandir
make
set +e
sudo kldload iwmfw/iwm-7265/iwm-7265-9.ko
set -e
sudo kldload driver/if_iwm.ko
sudo wlandebug -d 0xffffffff
sudo ifconfig wlan0 create wlandev iwm0
sudo wlandebug -d 0
sudo ifconfig wlan0 up channel 5 
sudo wpa_supplicant -c /etc/wpa_supplicant.conf -i wlan0 -B
