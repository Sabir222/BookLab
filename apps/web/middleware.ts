import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  const accessToken = request.cookies.get("booklab_access_token")?.value;
  const refreshToken = request.cookies.get("booklab_refresh_token")?.value;

  // If no access token but we have a refresh token, try to refresh
  if (!accessToken && refreshToken) {
    console.log(
      "🔄 No access token found in middleware, attempting refresh...",
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
        console.log("✅ Token refreshed successfully in middleware");

        // Create response that continues to the requested page
        const response = NextResponse.next();

        // Get the Set-Cookie header from refresh response
        const setCookieHeader = refreshRes.headers.get("set-cookie");
        if (setCookieHeader) {
          console.log("🍪 Setting new cookies from middleware");

          // Parse cookies and set them in the response
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
        // Clear invalid refresh token and redirect to login
        const response = NextResponse.redirect(new URL("/login", request.url));
        response.cookies.delete("booklab_refresh_token");
        response.cookies.delete("booklab_access_token");
        return response;
      }
    } catch (error) {
      console.error("❌ Error in middleware refresh:", error);
      // On error, continue but log it
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
