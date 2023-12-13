#!/bin/bash
me=$(whoami)
cd /home/$me/Downloads/linux-fake-battery-module/
echo My7skjawwaqert | sudo -S insmod ./fake_battery.ko
echo 'charging = 1' | sudo tee /dev/fake_battery
echo 'capacity0 = 88' | sudo tee /dev/fake_battery
echo 'capacity1 = 88' | sudo tee /dev/fake_battery
kill -9 $PPID
