FROM debian:buster-slim

RUN sed -i s/deb.debian.org/mirrors.cqu.edu.cn/ /etc/apt/sources.list &&\
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        libgtk2.0-0 libx11-xcb1 libxtst6 libnss3 libasound2 libdbus-glib-1-2 iptables xclip\
        dante-server tigervnc-standalone-server tigervnc-common dante-server psmisc flwm x11-utils\
        busybox libssl-dev && \
    ln -s "$(which busybox)" /usr/local/bin/ip

ARG EC_URL

RUN cd tmp &&\
    busybox wget "${EC_URL}" -O EasyConnect.deb &&\
    dpkg -i EasyConnect.deb && rm EasyConnect.deb

COPY ./docker-root /

RUN rm -f /usr/share/sangfor/EasyConnect/resources/conf/easy_connect.json

COPY ./patch/patch-7.6.7.tar /patch-7.6.7.tar

#RUN  ls -ltar /usr/share/sangfor/EasyConnect/resources

RUN tar xvf patch-7.6.7.tar && cp -fr ./EasyConnect/resources/* /usr/share/sangfor/EasyConnect/resources/ && \
rm -fr ./EasyConnect && rm -fr /patch-7.6.7.tar

#ENV TYPE="" PASSWORD="" LOOP=""
#ENV DISPLAY

VOLUME /root/ /usr/share/sangfor/EasyConnect/resources/logs/

CMD ["start.sh"]
