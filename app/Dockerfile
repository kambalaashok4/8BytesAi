
#FROM node:16
FROM  node:20-slim


WORKDIR /app

COPY package*.json ./


#RUN npm install

COPY . .
ENV NODE_OPTIONS=--openssl-legacy-provider


RUN npm run build

EXPOSE 3000

CMD [ "npm", "start" ]
