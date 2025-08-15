import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

function isTokenExpiringSoon(
  token: string,
  bufferMinutes: number = 5,
): boolean {
  try {
    const tokenParts = token.split(".");
    if (tokenParts.length !== 3 || !tokenParts[1]) {
      return true;
    }

    const payload = JSON.parse(
      Buffer.from(tokenParts[1]!, "base64").toString("utf-8"),
    );

    if (!payload.exp) return true;

    const expirationTime = payload.exp * 1000;
    const bufferTime = bufferMinutes * 60 * 1000;
    const currentTime = Date.now();

    return expirationTime - currentTime <= bufferTime;
  } catch (error) {
    console.error("Error decoding token:", error);
    return true;
  }
}

export async function middleware(request: NextRequest) {
  const accessToken = request.cookies.get("booklab_access_token")?.value;
  const refreshToken = request.cookies.get("booklab_refresh_token")?.value;

  if (!refreshToken) {
    return NextResponse.next();
  }

  const shouldRefresh = !accessToken || isTokenExpiringSoon(accessToken);

  if (shouldRefresh) {
    console.log(
      "🔄 Access token missing or expiring soon, attempting refresh...",
    );

    try {
      const refreshRes = await fetch(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/refresh`,
        {
          method: "POST",
          headers: {
            Cookie: `booklab_refresh_token=${refreshToken}`,
            "Content-Type": "application/json",
          },
        },
      );

      if (refreshRes.ok) {
        const response = NextResponse.next();
        const setCookieHeader = refreshRes.headers.get("set-cookie");

        if (setCookieHeader) {
          const cookieStrings = setCookieHeader.split(/,(?=\s*\w+\s*=)/);
          cookieStrings.forEach((cookieString) => {
            const trimmed = cookieString.trim();
            if (
              trimmed.includes("booklab_access_token") ||
              trimmed.includes("booklab_refresh_token")
            ) {
              response.headers.append("Set-Cookie", trimmed);
            }
          });
        }
        return response;
      } else {
        console.log(
          "❌ Token refresh failed in middleware, redirecting to login",
        );
        const response = NextResponse.redirect(new URL("/login", request.url));
        response.cookies.delete("booklab_refresh_token");
        response.cookies.delete("booklab_access_token");
        return response;
      }
    } catch (error) {
      console.error("Error in middleware refresh:", error);
      return NextResponse.next();
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - login, signup (auth pages)
     */
    "/((?!api|_next/static|_next/image|favicon.ico|login|signup).*)",
  ],
};
