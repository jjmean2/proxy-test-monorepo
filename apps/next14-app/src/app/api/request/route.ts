import { type NextRequest } from "next/server";
import ky from "ky";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  console.log("🚀 GET forward", request);
  return ky.get("http://koa-app:8001");
}
