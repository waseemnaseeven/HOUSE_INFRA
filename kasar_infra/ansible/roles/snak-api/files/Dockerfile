FROM node:20-alpine

WORKDIR /app

# Copie page HTML
COPY index.html /app/index.html

# Copie du mini serveur Node
COPY server.js /app/server.js

EXPOSE 8081
CMD ["node", "server.js"]