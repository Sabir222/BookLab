import { cookies } from "next/headers";

export async function serverFetch(url: string, options: RequestInit = {}) {
  const cookieStore = await cookies();
  const cookieHeader = cookieStore
    .getAll()
    .map(({ name, value }) => `${name}=${value}`)
    .join("; ");

  return fetch(url, {
    ...options,
    headers: {
      ...options.headers,
      cookie: cookieHeader,
    },
  });
}
