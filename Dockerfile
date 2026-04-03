# Stage 1: Backend development
FROM node:22 AS backend-dev
WORKDIR /usr/local/app
COPY backend/package*.json ./
RUN npm install
COPY backend/src ./src
CMD ["node", "./src/index.js"]

# Stage 2: Client development
FROM node:22 AS client-dev
WORKDIR /usr/local/app
COPY client/package*.json ./
RUN npm install
COPY client/src ./src
CMD ["npm", "run", "dev"]

# Stage 3: Backend production
FROM node:22 AS backend-prod
WORKDIR /app
COPY backend/package*.json ./
RUN npm install --production
COPY backend/src ./src
CMD ["node", "./src/index.js"]

# Stage 4: Client production build
FROM node:22 AS client-builder
WORKDIR /app
COPY client/package*.json ./
COPY client/index.html ./
COPY client/vite.config.js ./
COPY client/public ./public
RUN npm install
COPY client/src ./src
RUN npm run build

# Stage 5: Final production image (combines client build + backend)
FROM node:22 AS final
WORKDIR /app
COPY backend/package*.json ./
RUN npm install --production
COPY backend/src ./src
COPY --from=client-builder /app/dist ./src/static
CMD ["node", "./src/index.js"]
