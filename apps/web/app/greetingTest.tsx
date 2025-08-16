"use client";
import { useNavbarStore } from "@/components/navbar/navbarStore";

export function UserGreeting() {
        const user = useNavbarStore((state) => state.user);
        if (!user) return <p className="text-lg">Welcome, Guest!</p>;
        return <p className="text-lg font-medium">Hello, {user.username}!</p>;
}
