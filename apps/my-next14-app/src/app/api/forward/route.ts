import { type NextRequest } from "next/server";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  console.log("🚀 GET", request);
  const headers: Record<string, string> = {};
  Array.from(request.headers.entries()).forEach(([key, value]) => {
    headers[key] = value;
  });
  return Response.json({
    url: request.url,
    headers,
  });
}
