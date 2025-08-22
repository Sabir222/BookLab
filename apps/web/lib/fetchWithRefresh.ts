async function fetchWithRefresh(url: string, options: RequestInit = {}) {
  let res = await fetch(url, { ...options, credentials: "include" });
  console.log("Fetching:", url, "Status:", res.status);

  if (res.status === 401) {
    console.log("this is running because fetched response was 401 ✗");
    const refreshRes = await fetch(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/refresh`,
      { method: "POST", credentials: "include" },
    );
    console.log(refreshRes, "✓");

    if (refreshRes.ok) {
      res = await fetch(url, { ...options, credentials: "include" });
    }
  }
  return res;
}

export default fetchWithRefresh;
