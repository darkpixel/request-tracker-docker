#!/bin/sh
set -eo pipefail

envsubst '\$DATABASE_NAME \$DATABASE_HOST \$DATABASE_USER \$DATABASE_PASSWORD \$RT_NAME \$OWNER_EMAIL \$WEB_DOMAIN \$WEB_URL \$WEB_BASE_URL \$CORRESPOND_ADDRESS \$COMMENT_ADDRESS \$DATABASE_PORT \$WEB_PORT \$LOGO_URL \$LOGO_LINK_URL \$TIMEZONE \$WEB_SECURE_COOKIES' < /tmp/RT_SiteConfig.pm > /opt/rt5/etc/RT_SiteConfig.pm

envsubst '\$MAIL_HOST \$MAIL_PORT \$MAIL_USER \$MAIL_PASS \$CORRESPOND_ADDRESS' < /tmp/msmtprc > /etc/msmtprc

envsubst '\$WEB_URL \$WEB_BASE_URL \$MAIL_FETCH_LOGIN \$MAIL_FETCH_PASSWORD \$MAIL_FETCH_FOLDER \$MAIL_FETCH_COMMENT_FOLDER \$OWNER_EMAIL' < /tmp/fetchmailrc > /etc/fetchmailrc

case ${1} in
'--web'*)
  echo Starting RT webserver
  exec /opt/rt5/sbin/rt-server --server Starman --port 80
;;
'--cmd'*)
  echo Running command ${@:6}
  ${@:6}
;;
*)
  echo If you want to start the webserver pass --web
;;
esac
