async function fetchWithRefresh(url: string, options: RequestInit = {}) {
  let res = await fetch(url, { ...options, credentials: "include" });

  if (res.status === 401) {
    const refreshRes = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/refresh`,
      { method: "POST", credentials: "include" },
    );

    if (refreshRes.ok) {
      res = await fetch(url, { ...options, credentials: "include" });
    }
  }

  return res;
}

export default fetchWithRefresh;
