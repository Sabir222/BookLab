import fetchWithRefresh from "@/lib/fetchWithRefresh";

export type LoginResponse = {
  message: string;
  user: {
    id: string;
    username: string;
    email: string;
  } | null;
  accessToken: string;
};

const login = async (_previousState: unknown, formData: FormData) => {
  const username = formData.get("username") as string;
  const password = formData.get("password") as string;

  console.log("this run here ");
  if (!username || !password) {
    throw new Error("Login Informations Required");
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
      throw new Error("Failed to login!");
    }

    const data: LoginResponse = await res.json();

    return data;
  } catch (error: any) {
    console.error(error.message);
    return {
      message: error.message,
      user: null,
      accessToken: "",
    } as LoginResponse;
  }
};

export default login;
