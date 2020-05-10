FROM node:alpine
LABEL maintainer Jean Traullé <jean@opencomp.fr>

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ADD https://raw.githubusercontent.com/jsfiddle/togetherjs/v0.5.6/hub/server.js .
RUN sed -i "s/^var WEBSOCKET_COMPAT = true;/var WEBSOCKET_COMPAT = false;/" /usr/src/app/server.js

RUN npm install websocket optimist

EXPOSE 8080

CMD [ "node", "server.js", "--host", "0.0.0.0", "--port", "8080"]