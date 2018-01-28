FROM darkpixel/request-tracker-docker-base:latest
LABEL maintainer="Aaron C. de Bruyn <aaron@heyaaron.com>"

WORKDIR /opt/src
RUN curl -sLS "https://download.bestpractical.com/pub/rt/release/rt-4.4.2.tar.gz" | tar --strip-components=1 -xvzf - \
&& ./configure --enable-graphviz --enable-gd --with-db-type=Pg --with-db-host=database \
&& make testdeps && make install

RUN PERL_MM_USE_DEFAULT=1 cpan install \
RT::Extension::Announce \
RT::Extension::Gravatar \
RT::Extension::MergeUsers \
RT::Extension::QuickUpdate \
RT::Extension::RepeatTicket \
RT::Extension::ResetPassword \
#RT::Extension::REST2 \
RT::Extension::TicketLocking \
RT::Extension::BounceEmail \
RT::Action::SetPriorityFromHeader \
&& rm -rf /root/.cpan

RUN apk add --update gettext

WORKDIR /opt/rt4
COPY RT_SiteConfig.pm ./etc/RT_SiteConfig.pm.template
EXPOSE 80
CMD envsubst '\$DATABASE_HOST \$DATABASE_USER \$DATABASE_PASSWORD \$RT_NAME \$OWNER_EMAIL \$WEB_DOMAIN \$WEB_BASE_URL \
  \$CORRESPOND_ADDRESS \$COMMENT_ADDRESS \$DATABASE_PORT \$WEB_PORT \$LOGO_URL \$LOGO_LINK_URL \$TIMEZONE \
  \$WEB_SECURE_COOKIES' \
  < /opt/rt4/etc/RT_SiteConfig.pm.template \
  > /opt/rt4/etc/RT_SiteConfig.pm \
  && /opt/rt4/sbin/rt-server --port 80
