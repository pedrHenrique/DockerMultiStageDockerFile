# Dependências do Build
# Aqui construímos todas as deps do app com base numa imagem mais "completa"
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json .
RUN npm ci

# Build
COPY tsconfig.json tsconfig.json
COPY src src
RUN npm run build

# Dependências de execução
FROM node:22-alpine AS deps
WORKDIR /app
COPY package*.json .
RUN npm ci --only=production

# Run
# Aqui obtemos uma imagem distroless (+ leve, segura e difícil de trabalhar)
FROM gcr.io/distroless/nodejs22 
WORKDIR /app
COPY --from=deps /app/node_modules node_modules
COPY --from=build /app/dist dist 
ENV PORT=3000

# O NODE já é o ENTRYPOINT da imagem baixada. Por isso não precisamos mencionar o comando que será executado.... MT DAHORA!!
CMD ["dist/index.js"]

# Detalhe, por ser distroless, não conseguimos nem acessar o shell daquela máquina
# Qualquer atacante não vai conseguir acessar ou manusear o container
# Não vamos ter acesso as logs e etc