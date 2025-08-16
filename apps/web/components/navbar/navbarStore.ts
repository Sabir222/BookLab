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
}

export const useNavbarStore = create<NavbarState>((set) => ({
  isSearchOpen: false,
  isMenuOpen: false,
  openSearch: () => set({ isMenuOpen: false, isSearchOpen: true }),
  user: null,
  setUser: (u) => set({ user: u }),
  closeSearch: () => set({ isSearchOpen: false }),
  openMenu: () => set({ isSearchOpen: false, isMenuOpen: true }),
  closeMenu: () => set({ isMenuOpen: false }),
  closeAll: () => set({ isSearchOpen: false, isMenuOpen: false }),
}));

