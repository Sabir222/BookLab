import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

const refreshLocks = new Map<string, Promise<boolean>>();

function isTokenExpiringSoon(
  token: string,
  bufferMinutes: number = 5,
): boolean {
  try {
    const tokenParts = token.split(".");
    if (tokenParts.length !== 3 || !tokenParts[1]) {
      console.warn("Token format invalid — treating as expiring soon");
      return true;
    }

    const payload = JSON.parse(
      Buffer.from(tokenParts[1]!, "base64").toString("utf-8"),
    );

    if (!payload.exp) {
      console.warn("Token has no 'exp' field — treating as expiring soon");
      return true;
    }

    const expirationTime = payload.exp * 1000;
    const bufferTime = bufferMinutes * 60 * 1000;
    const currentTime = Date.now();
    const timeLeft = expirationTime - currentTime;

    if (timeLeft <= bufferTime) {
      console.log(
        `Token expiring soon — expires in ${Math.round(
          timeLeft / 1000,
        )}s (buffer: ${bufferMinutes}m) ✓`,
      );
      return true;
    } else {
      console.log(
        `Token still valid — expires in ${Math.round(
          timeLeft / 1000,
        )}s (buffer: ${bufferMinutes}m) ✓`,
      );
      return false;
    }
  } catch (error) {
    console.error("Error decoding token:", error);
    return true;
  }
}

async function performTokenRefresh(
  refreshToken: string,
): Promise<Response | null> {
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
      console.log("Token refreshed successfully in middleware ✓");
      return refreshRes;
    } else {
      console.log("Token refresh failed in middleware ✗");
      return null;
    }
  } catch (error) {
    console.error("Error in middleware refresh:", error);
    return null;
  }
}

async function refreshTokenWithLock(
  refreshToken: string,
): Promise<Response | null> {
  const lockKey = `refresh_${refreshToken}`;

  if (refreshLocks.has(lockKey)) {
    console.log("Refresh already in progress, waiting... ✓");
    await refreshLocks.get(lockKey);
    return null; // Return null to indicate we waited for another refresh
  }

  const refreshPromise = performTokenRefresh(refreshToken);
  refreshLocks.set(
    lockKey,
    refreshPromise.then(() => true).catch(() => false),
  );

  try {
    const result = await refreshPromise;
    return result;
  } finally {
    refreshLocks.delete(lockKey);
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
      " Access token missing or expiring soon, attempting refresh... ✓",
    );

    const refreshRes = await refreshTokenWithLock(refreshToken);

    if (refreshRes) {
      const response = NextResponse.next();
      const setCookieHeader = refreshRes.headers.get("set-cookie");

      if (setCookieHeader) {
        console.log(" Setting new cookies from middleware ✓");
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
    } else if (refreshRes === null && refreshLocks.size > 0) {
      console.log(" Refresh completed by another request, continuing... ✓");
      return NextResponse.next();
    } else {
      console.log(" Token refresh failed, redirecting to login ✗");
      const response = NextResponse.redirect(new URL("/login", request.url));
      response.cookies.delete("booklab_refresh_token");
      response.cookies.delete("booklab_access_token");
      return response;
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
