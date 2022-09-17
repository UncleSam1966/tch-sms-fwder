#!/bin/sh
fwdto=+61456789123
emlto=your@email.address

func_process_msg () {
	ubus call mobiled.sms get | jsonfilter -e '@.messages[*]' | while read msg
	do
		id=`echo $msg | jsonfilter -e '$.id'`
		number=`echo $msg | jsonfilter -e '$.number'`
		text=`echo $msg | jsonfilter -e '$.text'`
		date=`echo $msg | jsonfilter -e '$.date'`
		while true
		do
			ubus call mobiled status>sim.txt
			
			if grep -w -q "disabled" sim.txt; then
				echo -e"\n"
				echo -e "SIM not Inserted or Enabled. Unable to send SMS. Please Insert or Enable SIM\n"
			fi
			if grep -w -q "connected" sim.txt; then
				message=`echo -e "id: $id, number: $number, text: $text, date: $date" `
				echo -e $message
				echo -e "Subject: Incoming SMS\n\n$message" | sendmail $emlto
				ubus call mobiled.sms send '{ "number": "'"$fwdto"'", "message": "'"$message"'" }' && timeout 5 cat /dev/ttyUSB2 > status.txt
			fi
			if grep -w -q "OK" status.txt; then
				echo -e "\n"
				echo -e "###### SMS Sent ######\n"
				ubus call mobiled.sms delete "{\"id\":$id}"
				break
			elif grep -w -q "ERROR" status.txt; then
				echo -e "\n"
				echo -e "###### SMS Not Sent, Try Again ######"
				echo -e "\n"
			fi
			rm status.txt sim.txt
		done
	done
}

#clear message queue first
func_process_msg

#listen for events
ubus listen mobiled mobiled.sms | while read line
do
	echo $line | jsonfilter -e '@.mobiled.event'  && func_process_msg
done

