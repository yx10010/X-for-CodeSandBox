FROM node:latest
EXPOSE 3000
WORKDIR /home/appuser
COPY files/* /home/appuser/
ENV PM2_HOME=/tmp

RUN apt-get update &&\
    apt-get install -y iproute2 &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    addgroup --gid 10001 app &&\
    adduser --disabled-password  --no-create-home --uid 10001 --ingroup app appuser &&\
    usermod -aG sudo appuser &&    
    chmod +x web.js
ENTRYPOINT [ "node", "/server.js" ]

USER 10001
