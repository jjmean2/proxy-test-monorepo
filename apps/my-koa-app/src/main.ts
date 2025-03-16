import Koa from "koa";
import Router from "@koa/router";
import yargs from "yargs/yargs";
import { hideBin } from "yargs/helpers";

const argv = yargs(hideBin(process.argv)).option("p", {
  alias: "port",
  type: "number",
  description: "Port to run the server on",
  default: 8001,
}).argv;

const app = new Koa();
const router = new Router();

router.all("(.*)", (ctx) => {
  ctx.body = {
    url: ctx.request.url,
    headers: ctx.request.headers,
  };
});

app.use(router.routes()).use(router.allowedMethods());

const PORT = argv.p;

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
