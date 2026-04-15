# ETAP 1: Instalacja zależności
FROM node:20-alpine AS deps
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --frozen-lockfile

# ETAP 2: Testy i Budowanie
FROM node:20-alpine AS builder
RUN corepack enable && corepack prepare pnpm@latest --activate
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN pnpm test

RUN pnpm build

# ETAP 3: Produkcja (Runner)
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production

# Kopiujemy tylko to, co jest niezbędne do działania aplikacji
# Next.js potrzebuje folderów .next, public oraz node_modules produkcyjnych
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000

CMD ["npm", "start"]