# tch-sms-fwder
A simple SMS forwarder script tested on Technicolor DJA0231 - 20.3.c

I base this script on https://github.com/lowey71/tch-sms-smtp and https://github.com/pratikfarkase94/GSM-modem-SMS-Parser-Bash-Openwrt

Modify the variable "fwdto" in the script smsfwder.sh to point to your preferred mobile number in the international dialing format including the + and the country code: e.g. +61456789123

Modify the variable "emlto" in the script smsfwder.sh to point to your preferred eamil address. Note that you must configure an smtp client like this: https://openwrt.org/docs/guide-user/services/email/smtp.client#using_msmtp

If you wish to run the script on startup as a service, refer this page for how to: https://openwrt.org/docs/guide-developer/procd-init-script-example

The sendSMS.sh is a shell script that prompts you for a mobile number and the SMS you wish to send from the shell prompt
