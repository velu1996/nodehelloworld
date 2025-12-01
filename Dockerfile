FROM node:22-alpine 
WORKDIR /var/jenkins_home/nodehelloworld 
COPY . . 
RUN npm install 
EXPOSE 4848 
ENTRYPOINT ["npm", "start", "./index.js"] 
