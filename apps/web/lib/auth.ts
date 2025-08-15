import { cookies } from "next/headers";

export async function getServerAuth() {
  try {
    const cookieStore = await cookies();
    const accessToken = cookieStore.get("booklab_access_token")?.value;
    console.log(accessToken);

    if (!accessToken) {
      return null;
    }

    const res = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/me`,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
        },
        cache: "no-store",
      },
    );

    if (!res.ok) {
      console.warn(`Auth check failed with status: ${res.status}`);
      return null;
    }

    const data = await res.json();

    if (data.success) {
      return data;
    }

    return null;
  } catch (error) {
    console.error("Server auth check failed:", error);
    return null;
  }
}
