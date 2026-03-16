#!/bin/bash

readarray -t devices < ~/.secrets/bluetooth_headphones

notification_Length=3000


connectToDevice() {
    hyprctl notify -1 "$notification_Length" "rgb(74c7ec)" "Connection Successful"&
    pamixer -u
}

disconnectFromDevice() {
    hyprctl notify -1 "$notification_Length" "rgb(74c7ec)" "Attempting to Disconnect"&
    pamixer -m
    if bluetoothctl "disconnect" "$device_address"; then
        hyprctl notify -1 "$notification_Length" "rgb(74c7ec)" "Disconnect Successful"&
    else
        hyprctl notify -1 "$notification_Length" "rgb(74c7ec)" "Disconnect Failed"&
    fi
}



if ! systemctl is-active bluetooth; then
    sudo /sbin/systemctl start bluetooth.service
    sleep 2
fi


for device_address in "${devices[@]}"; do
    if bluetoothctl info "$device_address" 2>/dev/null | grep -q "Connected: yes"; then
        disconnectFromDevice
        exit
    fi
done

for device_address in "${devices[@]}"; do
    hyprctl notify -1 "$notification_Length" "rgb(74c7ec)" "Attempting to Connect to $device_address"&
    if timeout 3 bluetoothctl connect "$device_address" &>/dev/null; then
        connectToDevice
        exit
    fi
done
