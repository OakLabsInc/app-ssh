#!/bin/sh 

if [ -n "$SSH_ON" ]; then
  mkdir -p /run/sshd
  sed -i s/^.*Port.*/Port\ $SSH_PORT/ /etc/ssh/sshd_config 
  ssh-keygen -A
  /usr/sbin/sshd -e "$@"
fi

oak /app/src/index.js
