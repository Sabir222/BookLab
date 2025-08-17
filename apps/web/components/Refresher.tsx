"use client";
import fetchWithRefresh from "@/lib/fetchWithRefresh";
import { useEffect, useRef } from "react";

export default function TokenRefresher() {
        const lastRefresh = useRef<number>(0);

        useEffect(() => {
                const refresh = () => {
                        fetchWithRefresh(`${process.env.NEXT_PUBLIC_API_BASE_URL}/api/me`, { method: "POST" });
                        lastRefresh.current = Date.now();
                };

                console.log("refresher runned!! ✓");

                refresh();

                const interval = setInterval(() => {
                        const now = Date.now();
                        if (now - lastRefresh.current >= 5 * 60 * 1000) {
                                refresh();
                        }
                }, 10 * 60 * 1000); // every 10 min

                return () => clearInterval(interval);
        }, []);

        return null;
}
