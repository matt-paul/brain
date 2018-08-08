## Base runtime environment
ARG node_version="8.11.3"
FROM node:${node_version}-alpine AS base

## Production
FROM base AS production
ENV NODE_ENV production
ENV PORT 4000

# Create app directory
WORKDIR /app

COPY package.json ./

RUN npm install

COPY . .
EXPOSE 4000
ENTRYPOINT ["sh", "-c"]
CMD ["npm start"]
