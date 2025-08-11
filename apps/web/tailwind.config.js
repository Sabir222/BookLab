/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#2f2c2b",   // Dark gray
        secondary: "#b14446", // Dark red
        accent: "#ece8e2",    // Light beige
        muted: "#c2c0bb",     // Soft gray
        highlight: "#a2895e", // Gold
      }
    },
  },
  plugins: [],
};
