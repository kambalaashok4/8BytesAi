
#FROM node:16
FROM  node:18-slim


WORKDIR /app

COPY package*.json ./


RUN npm install

COPY ./app/ .
ENV NODE_OPTIONS=--openssl-legacy-provider


RUN npm run build

EXPOSE 3000

CMD [ "npm", "start" ]
