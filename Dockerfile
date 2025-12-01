FROM node:22-alpine 
WORKDIR /var/jenkins_home/Node_pipeline
COPY . . 
RUN npm install 
EXPOSE 4848 
ENTRYPOINT ["npm", "start", "./index.js"] 

