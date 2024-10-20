# FROM - Specify the base image that the build will extend
FROM node:17-alpine

# COPY - Copy the files that you select to the container
COPY . /app

# It's like moving the app directory
WORKDIR /app/src

# RUN - Install dependencies
RUN npm install

# Expose the port that we gonna listen from
EXPOSE 4000

# Run the command specified in the parameter
CMD ["node", "src/app.js"]