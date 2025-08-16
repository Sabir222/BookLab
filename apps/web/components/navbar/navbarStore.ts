import fetchWithRefresh from "@/lib/fetchWithRefresh";
import { ProfileUser } from "@/types";
import { create } from "zustand";

interface NavbarState {
  isSearchOpen: boolean;
  isMenuOpen: boolean;
  user: ProfileUser | null;
  setUser: (u: ProfileUser | null) => void;
  openSearch: () => void;
  closeSearch: () => void;
  openMenu: () => void;
  closeMenu: () => void;
  closeAll: () => void;
  logout: () => void;
}

export const useNavbarStore = create<NavbarState>((set) => ({
  isSearchOpen: false,
  isMenuOpen: false,
  openSearch: () => set({ isMenuOpen: false, isSearchOpen: true }),
  logout: () => {
    set({ user: null, isMenuOpen: false, isSearchOpen: false });
    console.log(
      `calling this ${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/logout`,
    );
    fetchWithRefresh(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/auth/logout`,
      {
        method: "POST",
        credentials: "include",
      },
    ).catch((err) => console.error("Logout failed", err));
  },
  user: null,
  setUser: (u) => set({ user: u }),
  closeSearch: () => set({ isSearchOpen: false }),
  openMenu: () => set({ isSearchOpen: false, isMenuOpen: true }),
  closeMenu: () => set({ isMenuOpen: false }),
  closeAll: () => set({ isSearchOpen: false, isMenuOpen: false }),
}));
