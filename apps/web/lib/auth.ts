import { cookies } from "next/headers";
import fetchWithRefresh from "./fetchWithRefresh";
import { ProfileUser } from "@/types";

export interface AuthApiResponse {
  success: boolean;
  user?: ProfileUser;
}
export async function getServerAuth(): Promise<ProfileUser | null> {
  try {
    const cookieStore = await cookies();
    const accessToken = cookieStore.get("booklab_access_token")?.value;
    if (!accessToken) {
      console.log("No access token found!");
      return null;
    }

    const res = await fetchWithRefresh(
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

    const data: AuthApiResponse = await res.json();

    if (data.success && data.user) {
      return data.user;
    }

    return null;
  } catch (error) {
    console.error("Server auth check failed:", error);
    return null;
  }
}
