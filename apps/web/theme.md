# BookLab Theme Documentation

## Current Color Palette

| Color Name     | Value      | Usage Description |
|----------------|------------|-------------------|
| Primary        | `#2f2c2b`  | Main text color |
| Secondary      | `#b14446`  | Accent color for interactive elements like buttons, links |
| Accent         | `#ece8e2`  | Background color |
| Muted          | `#c2c0bb`  | Subtle backgrounds, borders, secondary text |
| Highlight      | `#a2895e`  | Special emphasis, focus states, highlights |
| Background     | `#ece8e2`  | Main background color of the app |
| Foreground     | `#2f2c2b`  | Main text color |

## Component Usage

| Component          | Colors | Description |
|--------------------|--------|-------------|
| Navbar Background  | `#ece8e2` (accent) | Main navbar background |
| Navbar Text        | `#2f2c2b` (primary) | Main navigation text |
| Button Background  | `#b14446` (secondary) | Primary action buttons |
| Button Text        | `#ece8e2` (accent) | Text on primary buttons |
| Search Input       | `#ece8e2` (accent) | Search input background |
| Search Border      | `#c2c0bb` (muted) | Search input border |
| Link Text          | `#2f2c2b` (primary) | Standard link color |
| Link Hover         | `#b14446` (secondary) | Link hover state |
| Border             | `#c2c0bb` (muted) | General borders |

## CSS Variables

### Light Mode (:root)
```css
--background: #ece8e2;
--foreground: #2f2c2b;
--primary: #2f2c2b;
--primary-foreground: #ece8e2;
--secondary: #b14446;
--secondary-foreground: #ece8e2;
--accent: #ece8e2;
--accent-foreground: #2f2c2b;
--muted: #c2c0bb;
--muted-foreground: #2f2c2b;
--border: #c2c0bb;
--input: #c2c0bb;
--ring: #a2895e;
```

## Recommendations for Modifications

To make changes to the theme, modify the CSS variables in `app/globals.css` in the `:root` section.

For example, to change the primary color, modify:
```css
:root {
  --primary: #your-new-color;
}
```

