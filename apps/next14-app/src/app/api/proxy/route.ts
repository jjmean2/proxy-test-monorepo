import { type NextRequest } from "next/server";
import ky from "ky";

export const dynamic = "force-dynamic";

const defaultTarget = "http://proxy2:80/koa";

export async function GET(request: NextRequest) {
  console.log("🚀 GET proxy", request);
  const target = request.nextUrl.searchParams.get("target") || defaultTarget;
  const body = await request.text();
  return ky(target + request.nextUrl.pathname + request.nextUrl.search, {
    method: request.method,
    headers: {
      ...Object.fromEntries(Array.from(request.headers.entries())),
      host: new URL(target).host,
    },
    ...(body ? { body } : {}),
    throwHttpErrors: false,
  });
}
