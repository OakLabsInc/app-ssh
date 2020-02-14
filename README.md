# app-ssh

## Dockerfile

add something like this:
``` bash
RUN apk --update add --no-cache openssh bash \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && sed -i s/^.MaxAuthTries./MaxAuthTries\ 10/ /etc/ssh/sshd_config \
  && echo "root:r00t" | chpasswd
```

this is the port that allow ssh access to this container, must be in the 9000-9999 range

``` bash
ENV SSH_PORT="9922"
```

set SSH_ON to any string to enable ssh.
set SSH_ON to an empty string to disable ssh

``` bash
ENV SSH_ON="true"
```

In the entrypoint:

``` bash
if [ -n "$SSH_ON" ]; then
  sed -i s/^.Port./Port\ $SSH_PORT/ /etc/ssh/sshd_config
  ssh-keygen -A
  /usr/sbin/sshd -e "$@"
fi
```

The SSH_ON variable can be added to the JSON at install time to enable/disable ssh access. When it's on, the client would ssh to the machine's IP address on the port specified ( in this example port 9922 ) and have a shell in their container.

### Example

If the unit on your LAN has the IP of 192.168.1.30

``` bash
ssh root@192.168.1.30 -p 9922
```

## Install Snippet

``` bash
{
  "services": [
    {
      "image": "index.docker.io/oaklabs/app-ssh:latest",
      "environment": {
        "TZ": "America/Phoenix",
        "REMOTE_URL":"https://www.fast.com"
      }
    }
  ]
}
```
