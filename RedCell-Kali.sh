#!/bin/bash
source /etc/redcell-kali/RedCell-Kali.conf
export INSTALL_DIR=$INSTALL_DIR
cd $INSTALL_DIR
git pull && ./Kali_Updates.sh
