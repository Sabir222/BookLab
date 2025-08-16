import fetchWithRefresh from "@/lib/fetchWithRefresh";

export type LoginResponse = {
  message: string;
  user: {
    id: string;
    username: string;
    email: string;
  } | null;
  accessToken: string;
  error?: string;
};

const login = async (_previousState: unknown, formData: FormData) => {
  const username = formData.get("username") as string;
  const password = formData.get("password") as string;
  console.log("this run here ✓");

  if (!username || !password) {
    return {
      message: "",
      user: null,
      accessToken: "",
      error: "Login Information Required",
    } as LoginResponse;
  }

  try {
    const res = await fetchWithRefresh(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/login`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify({ username, password }),
      },
    );

    if (!res.ok) {
      return {
        message: "",
        user: null,
        accessToken: "",
        error: `Failed to login: ${res.status}`,
      } as LoginResponse;
    }

    const data: LoginResponse = await res.json();
    console.log(data.user);
    return data;
  } catch (error: unknown) {
    return {
      message: "",
      user: null,
      accessToken: "",
      error: (error as Error).message,
    } as LoginResponse;
  }
};

export default login;
