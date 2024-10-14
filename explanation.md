## 1. Choice of Base Image
 The base image used to build the containers is `node:16-alpine3.16`. 
 Used 
 1. Client:`node:16-alpine3.16`
 2. Backend: `node:16-alpine3.16`
 3. Mongo : `mongo:6.0 `
       

## 2. Dockerfile directives used in the creation and running of each container.
 For this project, I utilized two separate Dockerfiles: one for the Client and another for the Backend service.

**CLIENT DOCKERFILE**

```
# Build stage
FROM node:16-alpine3.16 as build-stage

# Set the working directory inside the container
WORKDIR /client

# Copy package.json and package-lock.json
COPY package*.json ./

# Install production dependencies, clean the npm cache, and remove temporary files
RUN npm install --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Copy remaining files into the container
COPY . .

# Build the application and remove unnecessary development dependencies
RUN npm run build && \
    npm prune --production

# Production
FROM node:16-alpine3.16 as production-stage

WORKDIR /client

# Copy essential files from the build stage
COPY --from=build-stage /client/build ./build
COPY --from=build-stage /client/public ./public
COPY --from=build-stage /client/src ./src
COPY --from=build-stage /client/package*.json ./

# Define the environment variable for the application
ENV NODE_ENV=production

# Expose the application’s port
EXPOSE 3000

# Prune the node_modules directory to remove development dependencies and clears the npm cache and removes any temporary files


# Start the application
CMD ["npm", "start"]

```
**BACKEND DOCKERFILE**

```
# Use a Node.js base image
FROM node:16-alpine3.16

# Set the working directory for the backend
WORKDIR /backend

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies and clears the npm cache and removes any temporary files
RUN npm install --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Copy the remaining application code into the container
COPY . .

# Define the environment variable for the application
ENV NODE_ENV=production

# Expose the backend service's port
EXPOSE 5000

# Remove development dependencies and clean up the npm cache
RUN npm prune --production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Start the backend service
CMD ["npm", "start"]

```

## 3. Docker Compose Networking COnfiguration
The docker-compose.yml file specifies the networking setup for the application, including how ports are allocated for each service. The key sections are outlined below:


```
services:
  backend:
    # ...
    ports:
      - "5000:5000"
    networks:
      - yolo-network

  client:
    # ...
    ports:
      - "3000:3000"
    networks:
      - yolo-network
  
  mongodb:
    # ...
    ports:
      - "27017:27017"
    networks:
      - yolo-network

networks:
  yolo-net:
    external: true
```
In this setup, the backend container is exposed on port 5000 of the host, the client container on port 3000, and the MongoDB container on port 27017. All services are interconnected through the app-network bridge, facilitating seamless communication between them.


## 4.  Docker Compose Volume Definition and Usage
The Docker Compose file includes volume definitions for MongoDB data storage. The relevant section is as follows:

yaml

```
volumes:
  mongodata:  # Define Docker volume for MongoDB data
    driver: local

```
This volume, mongodb_data, is designated for storing MongoDB data. It ensures that the data remains intact and is not lost even if the container is stopped or deleted.

## 5. Git Workflow to achieve the task

To achieve the task the following git workflow was used:

1. Fork the repository from: 'https://github.com/Vinge1718/yolo'
2. Clone the repo: 'https://github.com/Vinge1718/yolo'
3. Installed the necessary project dependencies: `git commit -m "Installed the necessary project dependencies."`
4. Installed dotenv package for loading mongodb environment variable: `git commit -m "Installed dotenv for loading database environment variables"`
5. I connected MongoDB and excluded env file in gitignore: `git commit -m "Connecting to MOngoDB and excluding the env file in gitignore"`
6. 
7. Added docker-compose file to the repo:
`git add docker-compose.yml`
8. Committed the changes:
`git commit -m "Added docker-compose file"`
9. Deleted the parent explanation.md file: `git commit -m "Deleted parent explanation.md file"`
10. Created explanation.md file: `"Created explanation.md file."`
11. Build the docker images: `git commit -m "Sudo docker-compose build"`
12. Push the docker images to dockerhub: `git commit -m "Images pushed to docker"`
13. Added an external network : `git commit -m "Added an external network"`
14. Added a README.md file with project explanation : `git commit -m "Added a README.md file with project explanation"`
15. Added screenshots of images in DockerHub: `git commit -m "Added screenshots of images in DockerHub"`
16. Pushed the project to GitHub - `git push -u origin master`