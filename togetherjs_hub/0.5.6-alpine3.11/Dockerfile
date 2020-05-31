FROM node:14-alpine3.11
LABEL maintainer Jean Traullé <jean@opencomp.fr>

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ADD https://raw.githubusercontent.com/jsfiddle/togetherjs/v0.5.6/hub/server.js .

# We disable Websocket_compat as it is no longer needed
# We add handling on SIGINT signal to permit fast shutdown of a compose/swarm stack
RUN sed -i "s/^var WEBSOCKET_COMPAT = true;/var WEBSOCKET_COMPAT = false;/" /usr/src/app/server.js && \
    echo "process.on('SIGINT', function() {\
       console.log( '\nGracefully shutting down from SIGINT (Ctrl-C)' );\
       process.exit(1);\
     });" >> /usr/src/app/server.js

RUN npm install websocket optimist

EXPOSE 8080

CMD [ "node", "server.js", "--host", "0.0.0.0", "--port", "8080"]