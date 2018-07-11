FROM resin/raspberrypi3-debian
RUN [ "cross-build-start" ]

RUN apt-get update && \
apt-get install -yqq curl git build-essential openssh-client  supervisor

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
&& apt-get install -yqq nodejs 

RUN curl -o wiringpi.tar.gz  "https://git.drogon.net/?p=wiringPi;a=snapshot;h=8d188fa0e00bb8c6ff6eddd07bf92857e9bd533a;sf=tgz" \
&&  mkdir /wiringPi \
&& tar -xzf wiringpi.tar.gz  -C /wiringPi --strip-components=1 \
&& cd /wiringPi/ \
&& ./build \
&& cd ..


RUN mkdir /code/ && mkdir /code/pusher/ 

COPY pusher/package.json  /code/pusher/package.json

RUN cd /code/pusher \
&& npm  install 

COPY pusher /code/pusher

RUN mkdir /code/extractor/ 
COPY extractor /code/extractor

RUN cd /code/extractor \
&& make 


RUN mkdir /sensordata




ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN [ "cross-build-end" ]  





ENTRYPOINT ["/usr/bin/supervisord"]


