FROM httpd:2.4
LABEL maintainer "matheus.arendt.hunsche@gmail.com"
RUN apt-get -y update \
    && apt-get -y install \
    curl \
    unzip \
    build-essential \
    zlib1g-dev \
    libcurl3 \
    libcurl4-gnutls-dev \
    xterm \
    libpq5 \
    sqlite3 \
    && ln -s /usr/lib/x86_64-linux-gnu/libpq.so.5 /usr/lib/x86_64-linux-gnu/libpq.so \
    && apt-get -y autoremove \
    && apt-get -y autoclean \
    && curl -L  http://ftp.br.debian.org/debian/pool/main/y/yajl/libyajl2_2.1.0-2+b3_amd64.deb > \
    /tmp/libyaj.deb \
    && dpkg -i /tmp/libyaj.deb  \
    && curl -L  http://ftp.br.debian.org/debian/pool/main/libb/libbson/libbson-1.0-0_1.4.2-1_amd64.deb > \
    /tmp/libbson.deb \
    && dpkg -i /tmp/libbson.deb  \
    && curl -L  http://ftp.br.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.0f-3+deb9u2_amd64.deb > \
    /tmp/libssl.deb \
    && dpkg -i /tmp/libssl.deb \
    && curl -L  http://ftp.br.debian.org/debian/pool/main/libm/libmongoc/libmongoc-1.0-0_1.4.2-1+b1_amd64.deb > \
    /tmp/libmongoc.deb \
    && dpkg -i /tmp/libmongoc.deb \
    && ln -s /usr/lib/x86_64-linux-gnu/libmongoc-1.0.so.0 /usr/lib/x86_64-linux-gnu/libmongoc-1.0.so \
    && ln -s /usr/lib/x86_64-linux-gnu/libbson-1.0.so.0 /usr/lib/x86_64-linux-gnu/libbson-1.0.so
ADD . /tmp
COPY httpd.conf /usr/local/apache2/conf
RUN cd /tmp \
    && curl -L \
    https://github.com/golang-migrate/migrate/releases/download/v3.4.0/migrate.linux-amd64.tar.gz > \
    /tmp/migrate.tar.gz \
    && tar -xzvf migrate.tar.gz \
    && mv migrate.linux-amd64 /usr/bin/migrate \
    && curl -L http://altd.embarcadero.com/download/interbase/2017/latest/InterBase_2017_EN.zip > \
    interbase.zip \
    && unzip interbase.zip \
    && chmod +x ib_install_linux_x86_64.bin \
    && ./ib_install_linux_x86_64.bin -i silent -r /tmp/output || true \
    && cat output \
    && tar -xzvf emsserver.tar.gz \
    && cd emsserver \ 
    && ./ems_install.sh \
    && ln -s /usr/lib/ems/EMSDevConsoleCommand /usr/bin/ems-console \
    && curl -L \
    https://github.com/maxcnunes/waitforit/releases/download/v2.2.0/waitforit-linux_amd64 > \
    /usr/bin/waitforit \
    && chmod +x /usr/bin/waitforit \
    && mv /tmp/start.sh ~/ \
    && sed -i -e 's/\r$//' ~/start.sh \
    && chmod +x ~/start.sh \
    && ln -s ~/start.sh /usr/bin/start \
    && rm -rf /tmp/*
WORKDIR ~/
EXPOSE 64211
ENV RAD_SERVER_RESOURCES_FILES=/etc/ems/objrepos/
ENV RAD_SERVER_CONSOLE_PORT=8081
ENV RAD_SERVER_CONSOLE_PASS=consolepass
ENV RAD_SERVER_CONSOLE_USER=consoleuser
ENV RAD_SERVER_SERVER_PORT=8080
ENV RAD_SERVER_DB_USERNAME=sysdba
ENV RAD_SERVER_DB_PASSWORD=masterkey
CMD ["start"]
