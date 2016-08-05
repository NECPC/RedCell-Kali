#!/bin/bash

## MUST BE RUN FROM SINGLE USER MODE

## Needed this for previous Kali versions
#killall dhclient;

mount -o remount,ro /
zerofree /dev/sda1
shutdown now -h
