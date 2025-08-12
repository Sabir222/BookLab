import { create } from 'zustand';

interface NavbarState {
  isSearchOpen: boolean;
  isMenuOpen: boolean;
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
  closeSearch: () => set({ isSearchOpen: false }),
  openMenu: () => set({ isSearchOpen: false, isMenuOpen: true }),
  closeMenu: () => set({ isMenuOpen: false }),
  closeAll: () => set({ isSearchOpen: false, isMenuOpen: false }),
}));