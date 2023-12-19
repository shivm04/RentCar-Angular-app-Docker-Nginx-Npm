#FROM node:16-alpine AS build
#WORKDIR .
#COPY . .
#RUN npm install
#RUN ng build --prod || true

#FROM nginx:1.23-alpine
#MAINTAINER Groots DevOps Team
#RUN rm -rf /usr/share/nginx/html/*
#COPY ./dist/RentACar-FrontEnd /usr/share/nginx/html
#WORKDIR /usr/share/nginx/html
#RUN ls -l
#ADD nginx.conf /etc/nginx/conf.d/client.conf
#RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf_original

FROM node:16-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build

### STAGE 2: Run ###
FROM nginx:1.17.1-alpine
WORKDIR /usr/share/nginx/html
ADD nginx.conf /etc/nginx/conf.d/client.conf
COPY --from=build /app/dist/RentACar-FrontEnd/ /usr/share/nginx/html
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf_original

