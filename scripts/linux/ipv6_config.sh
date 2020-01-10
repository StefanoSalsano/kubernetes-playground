#!/bin/bash

DEVICE=$(ip -o addr show scope global | awk -F: '$2 ~ "192.168.0."{print $2}' | awk '{print $1}')

ip -6 address add $1 dev $DEVICE
