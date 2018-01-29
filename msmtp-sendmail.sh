#!/bin/sh
/usr/bin/msmtp -t
/usr/bin/logger -t RTmailer -p syslog.info -- CALL /usr/bin/msmtp -nt "$@" RETURNED $?
