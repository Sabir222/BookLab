"use client";
import { useEffect } from "react";
import { ProfileUser } from "@/types";
import { useNavbarStore } from "./navbar/navbarStore";

type Props = {
        user: ProfileUser | null;
};

export function AuthHydrator({ user }: Props) {
        const setUser = useNavbarStore((state) => state.setUser);

        useEffect(() => {
                setUser(user);
        }, [user, setUser]);

        return null;
}
