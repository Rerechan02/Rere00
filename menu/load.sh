#!/bin/bash
spinner()
{
    local pid=$!
    local delay=0.1
    local spinstr='9876543210'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

echo "Proses sedang berjalan..."
sleep 1 & spinner
echo "Proses selesai."