FROM ubuntu:14.04
MAINTAINER Jasmin Beganović <bjasko@bring.out.ba>
ENV PG_MAJOR 9.1

# pre-instalation requirements  
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN groupadd -r postgres && useradd -r -g postgres postgres
RUN alias adduser='useradd'  

# make the "bs_BA.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i bs_BA -c -f UTF-8 -A /usr/share/locale/locale.alias bs_BA.UTF-8 \
    && locale-gen bs_BA.UTF-8 \
    && update-locale LANG=bs_BA.UTF-8

# set the correct timezone
RUN echo "Europe/Sarajevo" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# apt-get psql + utils 
RUN apt-get update && apt-get -y -q install python-software-properties software-properties-common curl
RUN apt-get -y -q install postgresql-9.1 postgresql-client-9.1 postgresql-contrib-9.1
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/


ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
CMD ["app:start"]
