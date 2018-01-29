#!/bin/sh
set -eo pipefail

envsubst '\$DATABASE_HOST \$DATABASE_USER \$DATABASE_PASSWORD \$RT_NAME \$OWNER_EMAIL \$WEB_DOMAIN \$WEB_BASE_URL \$CORRESPOND_ADDRESS \$COMMENT_ADDRESS \$DATABASE_PORT \$WEB_PORT \$LOGO_URL \$LOGO_LINK_URL \$TIMEZONE \$WEB_SECURE_COOKIES' < /tmp/RT_SiteConfig.pm > /opt/rt4/etc/RT_SiteConfig.pm

envsubst '\$MAIL_HOST \$MAIL_PORT \$MAIL_USER \$MAIL_PASS \$CORRESPOND_ADDRESS' < /tmp/msmtprc > /etc/msmtprc

case ${1} in
'--web'*)
  echo Starting RT webserver
  exec /opt/rt4/sbin/rt-server --port 80
;;
'--cron'*)
  echo cron
  exec /usr/sbin/crond -f -m $OWNER_EMAIL
;;
'--fetchmail'*)
  echo fetch
  exec fetchmail
;;
'--debug'*)
  echo debug
  exec sh
;;
*)
  echo You must pass --web --cron or --fetchmail as a parameter
;;
esac
