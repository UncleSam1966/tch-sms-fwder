#!/bin/sh

ubus call mobiled status>sim.txt

if grep -w -q "disabled" sim.txt; then
	echo -e"\n"
	echo -e "SIM not Inserted or Enabled. Unable to send SMS. Please Insert or Enable SIM\n"
fi
if grep -w -q "connected" sim.txt; then
	echo -e "Enter the NUMBER you want to send to\n\n--->\c"
	read NUMBER
	echo -e "Enter the MESSAGE TEXT you want to send (160 characters)\n.........1.........2.........3.........4.........5.........6.........7.........8.........9.........0.........1.........2.........3.........4.........5.........6"
	read -n 160 MESSAGE
	ubus call mobiled.sms send '{ "number": "'"$NUMBER"'", "message": "'"$MESSAGE"'" }' && timeout 5 cat /dev/ttyUSB2 > status.txt
fi

if grep -w -q "OK" status.txt; then
	echo -e "\n"
	echo -e "###### SMS Sent ######\n"
	elif grep -w -q "ERROR" status.txt; then
	echo -e "\n"
	echo -e "###### SMS Not Sent, Try Again ######"
	echo -e "\n"
fi

rm status.txt sim.txt