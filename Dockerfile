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
RUN pnpm deploy --filter=my-koa-app --prod /prod/my-koa-app
RUN pnpm deploy --filter=my-next14-app --prod /prod/my-next14-app

FROM base AS my-koa-app
COPY --from=build /prod/my-koa-app /prod/my-koa-app
WORKDIR /prod/my-koa-app
EXPOSE 8001
CMD ["pnpm", "start"]

FROM base AS my-next14-app
COPY --from=build /prod/my-next14-app /prod/my-next14-app
WORKDIR /prod/my-next14-app
EXPOSE 8000
CMD ["pnpm", "start"]
