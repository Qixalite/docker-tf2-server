from debian:buster-slim
maintainer Alex Butler <alex@alex-j-butler.com>

RUN dpkg --add-architecture i386
RUN apt-get -y update

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install lib32gcc1 \
	lib32stdc++6 \
	libcurl4-gnutls-dev:i386

ENV USER tf-server

RUN useradd $USER
ENV HOME /home/$USER
RUN mkdir $HOME
RUN chown $USER:$USER $HOME
RUN apt-get install -y wget

USER $USER
ENV SERVER $HOME/tfserver
RUN mkdir $SERVER

RUN wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz
ADD scripts/install_sourcemod.sh $SERVER/
ADD tf2_ds.txt update.sh tf.sh $SERVER/

RUN $SERVER/update.sh
RUN $SERVER/install_sourcemod.sh

ADD shared/custom_maps shared/match_configs $SERVER/srcds/tf/custom/

EXPOSE 27015/udp 27015/tcp 27020/udp 27020/tcp

WORKDIR /home/$USER/tfserver
ENTRYPOINT ["./tf.sh"]
CMD ["+sv_pure", "2", "-port", "27015", "+tv_port", "27020", "+rcon_password", "test123", "+sv_password", "example123"]
