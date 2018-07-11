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






RUN mkdir /root/.ssh/
# Copy over private key, and set permissions
ADD privateSSH  /root/.ssh/id_rsa

RUN chmod 400 /root/.ssh/id_rsa \
&& touch /root/.ssh/known_hosts \
&& ssh-keyscan vs-ssh.visualstudio.com >> /root/.ssh/known_hosts 



# Clone the conf files into the docker container
RUN git clone ssh://miguelAlfonsoRuiz@vs-ssh.visualstudio.com:22/OregonSensor/_ssh/OregonSensor \
&& cd /OregonSensor/OregonSensor \
&& make \
&& cd .. \
&& cd .. \
&& mkdir sensordata


# Clone node project
RUN git clone ssh://miguelAlfonsoRuiz@vs-ssh.visualstudio.com:22/TemperatureSensorReadingProcessor/_ssh/TemperatureSensorReadingProcessor \
&& cd /TemperatureSensorReadingProcessor \
&& npm install 





ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN [ "cross-build-end" ]  





ENTRYPOINT ["/usr/bin/supervisord"]


