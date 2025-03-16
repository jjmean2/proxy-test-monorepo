# syntax=docker/dockerfile:1
FROM node:20-alpine3.20 as base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

FROM base AS build
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run -r build
RUN pnpm deploy --filter=koa-app --prod /prod/koa-app
RUN pnpm deploy --filter=next14-app --prod /prod/next14-app

FROM base AS koa-app
COPY --from=build /prod/koa-app /prod/koa-app
WORKDIR /prod/koa-app
EXPOSE 8001
CMD ["pnpm", "start"]

FROM base AS next14-app
COPY --from=build /prod/next14-app /prod/next14-app
WORKDIR /prod/next14-app
EXPOSE 8000
CMD ["pnpm", "start"]
