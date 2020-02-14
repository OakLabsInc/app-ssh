FROM oaklabs/oak:5.0.9

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y openssh-server bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && sed -i s/^.*MaxAuthTries.*/MaxAuthTries\ 10/ /etc/ssh/sshd_config \
  && echo "root:r00t" | chpasswd

# this is the port that allow ssh access to this container, must be in the 9000-9999 range
ENV SSH_PORT="9922"

# set SSH_ON to any string to enable ssh.
# set SSH_ON to an empty string to disable ssh
ENV SSH_ON="true"

RUN npm i --engine-strict=true --progress=false --loglevel="error" \
    && npm cache clean --force


ENV NODE_ENV=production \
    REMOTE_URL=https://www.zivelo.com

EXPOSE 9922

COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh
ENTRYPOINT ["./entrypoint.sh"]
