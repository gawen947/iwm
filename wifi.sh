#!/bin/sh
#  Copyright (c) 2016, David Hauweele <david@hauweele.net>
#  All rights reserved.
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice, this
#      list of conditions and the following disclaimer.
#   2. Redistributions in binary form must reproduce the above copyright notice,
#      this list of conditions and the following disclaimer in the documentation
#      and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
#  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
#  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

select_chan() {
  chan="$1"
  ifconfig wlan0 down
  ifconfig wlan0 channel "$chan"
  ifconfig wlan0 up
}

case "$1" in
  load)
    kldload  if_iwm
    ifconfig wlan0 create wlandev iwm0
    ;;
  start)
    chan="$2"

    if [ -z "$chan" ]
    then
      echo "Except channel..."
      exit 1
    fi

    echo "Restart interface..."
    service netif restart

    echo "Kill wpa_supplicant"
    killall wpa_supplicant


    echo -n "Configure channel $chan... "
    select_chan "$chan"
    echo "done!"

    echo "Starting wpa_supplicant..."
    wpa_supplicant -i wlan0 -c/etc/wpa_supplicant.conf
    ;;
  scan)
    scan_chan() {
      chan="$1"

      select_chan "$chan"
      sleep 2
      ifconfig wlan0 scan
    }

    for chan in $(seq 1 13)
    do
      scan_chan "$chan"
    done
    ;;
  unload)
    ifconfig wlan0 down
    kldunload if_iwm
    ;;
esac
