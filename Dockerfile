# FROM node:16-alpine # Dockerhub tem limite de pull
FROM public.ecr.aws/docker/library/node:16-alpine

WORKDIR /frontend

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD npm run dev
