FROM ghcr.io/darkpixel/request-tracker-docker-base/request-tracker-docker-base:0.9.5
LABEL maintainer="Aaron C. de Bruyn <aaron@heyaaron.com>"

WORKDIR /opt/src
RUN curl -sLS "https://download.bestpractical.com/pub/rt/release/rt-5.0.1.tar.gz" | tar --strip-components=1 -xvzf - \
&& ./configure --enable-graphviz --enable-gd --with-db-type=Pg --with-db-host=database --enable-externalauth \
&& make testdeps && make install

RUN PERL_MM_USE_DEFAULT=1 cpan install \
RT::Extension::Gravatar \
RT::Extension::MergeUsers \
&& rm -rf /root/.cpan

RUN c_rehash /usr/share/ca-certificates/mozilla

COPY RT_SiteConfig.pm /tmp/RT_SiteConfig.pm
COPY msmtprc /tmp/msmtprc
COPY fetchmailrc /tmp/fetchmailrc
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY msmtp-sendmail.sh /usr/local/bin/msmtp-sendmail.sh

RUN adduser -D -h /opt/rt5 -s /bin/sh -u 1000 rtuser
RUN chown -R 1000 /opt/rt5
RUN chmod -R u+rw /opt/rt5/etc/*
USER rtuser

WORKDIR /opt/rt5

EXPOSE 80
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/entrypoint.sh"]
