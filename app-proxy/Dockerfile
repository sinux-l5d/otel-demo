# Stage 1: Build
FROM node:22 AS build

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY package*.json ./

# Install dependencies.
RUN npm install

# Copy local code to the container image.
COPY . .

# Stage 2: Runtime
FROM node:22-alpine

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy only the necessary files from the build stage.
COPY --from=build /usr/src/app ./

# Run the web service on container startup.
ENTRYPOINT [ "node", "server.js" ]

# Document that the service listens on port 8080.
EXPOSE 8080