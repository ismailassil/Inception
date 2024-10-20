FROM node:apline

COPY . /app

WORKDIR /app/src

CMD node app.js

# FROM debian:bullseye
