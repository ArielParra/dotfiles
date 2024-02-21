#!/usr/bin/env sh

load_average=$(uptime | awk -F'[a-z]:' '{ print $2 }' | awk -F',' '{ print $1 }' | tr -d ' ')
load_integer=$(printf "%.0f" "$load_average")

echo "      /\\                      " 
echo "     /  \\                     " 
echo "    /\\   \\             _     "
echo "   /      \\    _ __ ___| |__  " 
echo "  /   ,,   \\  | '__/ __| '_ \ " 
echo " /   |  |  -\\ | | | (__| | | |" 
echo "/_-''    ''-_\\ _|  \___|_| |_|" 
echo ""
echo "Welcome to $(awk -F= '/^NAME/{gsub(/"/, "", $2); printf "%s", $2}' /etc/os-release), kernel: $(uname -r)"
echo ""
echo "System load:   $((load_integer * 100 / 100))%               Up time:       $(uptime -p | sed 's/up //')"
echo "Memory usage:  $(free -m | awk '/Mem/ {printf "%d%% of %.2fG\n", $3/$2*100, $2/1024}')     IP:            $(ip addr show | awk '/inet / {printf $2" "}')"
echo "CPU temp:      $(sensors | awk '/^temp/{print $2}' | head -n 1 | sed 's/+//')           Usage of /:    $(df -h / | awk '/\// {print $5" of "$2}')"
