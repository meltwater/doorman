FROM docker.meltwater.com/nginx-passenger-nodejs:latest
MAINTAINER Seb Geidies "seb@meltwater.com"

# prerequisites - an installation dir and chown to user that will run the app.
RUN mkdir -p /home/app/webapp 
ADD . /home/app/webapp/.
RUN chown -R app:app /home/app/webapp

# Expose Nginx HTTP service
EXPOSE 8080

# install the npm dependencies. http-proxy pre 1.11.0 has a conflict with eventemitter
# in the later version required by something else.
WORKDIR /home/app/webapp
RUN npm install

# simple site.conf.
ADD nginx.conf /etc/nginx/sites-enabled/webapp.conf

# app config.
# TODO: you need to replace this with getting a real conf.js
#       from a safe place somewhere. Do not check-in secrets
#       to source control!!
ADD conf.example.js /home/app/webapp/conf.js

# start it up
EXPOSE 8080
CMD ["nginx"]
=======
FROM node

ADD . /doorman

RUN \
  cd /doorman && \
  npm install && \
  mv conf.environment.js conf.js

WORKDIR /doorman

ENTRYPOINT [ "npm", "start" ]
