#!/bin/sh

if iwctl station wlan0 show | grep -q "connected"; then
    icon=""
    ssid=Amadeus
    status="Connected to ${ssid}"
else
    icon="睊"
    status="offline"
fi

echo "{\"icon\": \"${icon}\", \"status\": \"${status}\"}" 
