import fetchWithRefresh from "@/lib/fetchWithRefresh";

export type SignupResponse = {
  message: string;
  user: {
    id: string;
    username: string;
    email: string;
  } | null;
  accessToken: string;
  error?: string;
};

const signup = async (_previousState: unknown, formData: FormData) => {
  const username = formData.get("username") as string;
  const email = formData.get("email") as string;
  const password = formData.get("password") as string;

  if (!username || !email || !password) {
    return {
      message: "",
      user: null,
      accessToken: "",
      error: "All fields are required",
    } as SignupResponse;
  }

  try {
    const res = await fetchWithRefresh(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/signup`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify({ username, email, password }),
      },
    );

    if (!res.ok) {
      const errorData = await res.json().catch(() => ({}));
      return {
        message: "",
        user: null,
        accessToken: "",
        error: errorData.message || `Failed to signup: ${res.status}`,
      } as SignupResponse;
    }

    const data: SignupResponse = await res.json();
    return data;
  } catch (error: unknown) {
    return {
      message: "",
      user: null,
      accessToken: "",
      error: (error as Error).message,
    } as SignupResponse;
  }
};

export default signup;