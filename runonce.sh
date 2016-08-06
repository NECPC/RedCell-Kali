#!/bin/bash
if [ ! -d /etc/redcell-kali ]; then
  mkdir /etc/redcell-kali
fi
echo "INSTALL_DIR=`pwd`" > /etc/redcell-kali/RedCell-Kali.conf
