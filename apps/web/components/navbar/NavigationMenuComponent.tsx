"use client";
import {
  NavigationMenu,
  NavigationMenuContent,
  NavigationMenuItem,
  NavigationMenuLink,
  NavigationMenuList,
  NavigationMenuTrigger,
} from "@/components/ui/navigation-menu";
import { cn } from "@/lib/utils";
import Link from "next/link";

const navigationItems = [
  { title: "Book Categories" },
  { title: "Comics" },
  { title: "Manga" },
  { title: "Ereaders" },
];

const bookCategories = [
  {
    title: "Main Categories",
    items: [
      { title: "Fiction", href: "/category/fiction" },
      { title: "Non-Fiction", href: "/category/non-fiction" },
      { title: "Children Books", href: "/category/children-books" },
      { title: "Kids", href: "/category/kids" },
    ]
  },
  {
    title: "Special Categories",
    items: [
      { title: "Education", href: "/category/education" },
      { title: "Lifestyle & Hobbies", href: "/category/lifestyle-hobbies" },
      { title: "All Categories", href: "/category" },
    ]
  },
  {
    title: "Popular Genres",
    items: [
      { title: "Bestsellers", href: "/bestsellers" },
      { title: "Award-Winning Books", href: "/awards" },
      { title: "Trending on BookTok", href: "/trending" },
    ]
  }
];

const comicsCategories = [
  {
    title: "Publishers",
    items: [
      { title: "Marvel", href: "/category/comics/marvel" },
      { title: "DC Comics", href: "/category/comics/dc" },
      { title: "Image Comics", href: "/category/comics/image" },
      { title: "Dark Horse", href: "/category/comics/dark-horse" },
      { title: "IDW Publishing", href: "/category/comics/idw" },
    ]
  },
  {
    title: "Genres",
    items: [
      { title: "Superhero", href: "/category/comics/genres/superhero" },
      { title: "Fantasy", href: "/category/comics/genres/fantasy" },
      { title: "Sci-Fi", href: "/category/comics/genres/sci-fi" },
      { title: "Horror", href: "/category/comics/genres/horror" },
      { title: "Manga Style", href: "/category/comics/genres/manga-style" },
    ]
  },
  {
    title: "Popular Series",
    items: [
      { title: "Spider-Man", href: "/category/comics/series/spider-man" },
      { title: "Batman", href: "/category/comics/series/batman" },
      { title: "X-Men", href: "/category/comics/series/x-men" },
      { title: "Avengers", href: "/category/comics/series/avengers" },
      { title: "Watchmen", href: "/category/comics/series/watchmen" },
    ]
  }
];

const mangaCategories = [
  {
    title: "Genres",
    items: [
      { title: "Shonen", href: "/category/manga/genres/shonen" },
      { title: "Shojo", href: "/category/manga/genres/shojo" },
      { title: "Seinen", href: "/category/manga/genres/seinen" },
      { title: "Josei", href: "/category/manga/genres/josei" },
      { title: "Kodomo", href: "/category/manga/genres/kodomo" },
    ]
  },
  {
    title: "Popular Titles",
    items: [
      { title: "One Piece", href: "/category/manga/titles/one-piece" },
      { title: "Naruto", href: "/category/manga/titles/naruto" },
      { title: "Demon Slayer", href: "/category/manga/titles/demon-slayer" },
      { title: "Attack on Titan", href: "/category/manga/titles/attack-on-titan" },
      { title: "My Hero Academia", href: "/category/manga/titles/my-hero-academia" },
    ]
  },
  {
    title: "Publishers",
    items: [
      { title: "Shueisha", href: "/category/manga/publishers/shueisha" },
      { title: "Kodansha", href: "/category/manga/publishers/kodansha" },
      { title: "Viz Media", href: "/category/manga/publishers/viz-media" },
      { title: "Dark Horse", href: "/category/manga/publishers/dark-horse" },
      { title: "Seven Seas", href: "/category/manga/publishers/seven-seas" },
    ]
  }
];

const ereaderCategories = [
  {
    title: "Ereader Devices",
    items: [
      { title: "Kindle", href: "/category/ereaders/kindle" },
      { title: "Kobo", href: "/category/ereaders/kobo" },
      { title: "Nook", href: "/category/ereaders/nook" },
      { title: "iPad", href: "/category/ereaders/ipad" },
      { title: "Android Tablets", href: "/category/ereaders/android-tablets" },
    ]
  },
  {
    title: "Ereader Accessories",
    items: [
      { title: "Cases", href: "/category/ereaders/accessories/cases" },
      { title: "Screen Protectors", href: "/category/ereaders/accessories/screen-protectors" },
      { title: "Chargers", href: "/category/ereaders/accessories/chargers" },
    ]
  }
];

export function NavigationMenuComponent() {
  return (
    <div className="border-t border-border/50 pt-2">
      <NavigationMenu className="w-full">
        <NavigationMenuList>
          {/* Book Categories */}
          {navigationItems.filter(item => item.title === "Book Categories").map((category) => (
            <NavigationMenuItem key={category.title}>
              <NavigationMenuTrigger className="bg-transparent font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent className="backdrop-blur-sm bg-accent/80 border border-border">
                <ul className="grid w-[600px] gap-3 p-4 md:w-[500px] md:grid-cols-3 lg:w-[600px] sm:grid-cols-3">
                  {bookCategories.map((section) => (
                    <li key={section.title} className="row-span-3">
                      <NavigationMenuLink asChild>
                        <div className="flex h-full w-full flex-col">
                          <h3 className={cn(
                            "text-sm font-medium",
                            section.title.includes("Popular")
                              ? "text-primary font-bold"
                              : "text-secondary"
                          )}>
                            {section.title}
                          </h3>
                          <ul className="mt-2 space-y-2">
                            {section.items.map((item) => (
                              <li key={item.title}>
                                <Link
                                  href={item.href}
                                  className="block rounded-md p-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-secondary transition-colors"
                                >
                                  {item.title}
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </NavigationMenuLink>
                    </li>
                  ))}
                </ul>
              </NavigationMenuContent>
            </NavigationMenuItem>
          ))}

          {/* Comics */}
          {navigationItems.filter(item => item.title === "Comics").map((category) => (
            <NavigationMenuItem key={category.title}>
              <NavigationMenuTrigger className="bg-transparent font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent>
                <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2 lg:w-[600px]">
                  {comicsCategories.map((section) => (
                    <li key={section.title}>
                      <NavigationMenuLink asChild>
                        <div className="block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground">
                          <div className="text-sm font-medium leading-none">{section.title}</div>
                          <ul className="mt-2 space-y-1">
                            {section.items.map((item) => (
                              <li key={item.title}>
                                <Link
                                  href={item.href}
                                  className="block rounded-md p-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-secondary transition-colors"
                                >
                                  {item.title}
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </NavigationMenuLink>
                    </li>
                  ))}
                  <li className="row-span-3">
                    <NavigationMenuLink asChild>
                      <div className="flex h-full w-full flex-col justify-end rounded-md bg-gradient-to-b from-muted/50 to-muted p-6 no-underline outline-none focus:shadow-md">
                        <Link href="/comics">
                          <div className="mb-2 mt-4 text-lg font-medium">{category.title} Collection</div>
                          <p className="text-sm leading-tight text-muted-foreground">
                            Explore our collection of superhero comics, indie hits, and graphic novels.
                          </p>
                        </Link>
                      </div>
                    </NavigationMenuLink>
                  </li>
                </ul>
              </NavigationMenuContent>
            </NavigationMenuItem>
          ))}

          {/* Manga */}
          {navigationItems.filter(item => item.title === "Manga").map((category) => (
            <NavigationMenuItem key={category.title}>
              <NavigationMenuTrigger className="bg-transparent font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent>
                <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2 lg:w-[600px]">
                  {mangaCategories.map((section) => (
                    <li key={section.title}>
                      <NavigationMenuLink asChild>
                        <div className="block select-none space-y-1 rounded-md p-3 leading-none no-underline outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus:bg-accent focus:text-accent-foreground">
                          <div className="text-sm font-medium leading-none">{section.title}</div>
                          <ul className="mt-2 space-y-1">
                            {section.items.map((item) => (
                              <li key={item.title}>
                                <Link
                                  href={item.href}
                                  className="block rounded-md p-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-secondary transition-colors"
                                >
                                  {item.title}
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </NavigationMenuLink>
                    </li>
                  ))}
                  <li className="row-span-3">
                    <NavigationMenuLink asChild>
                      <div className="flex h-full w-full flex-col justify-end rounded-md bg-gradient-to-b from-muted/50 to-muted p-6 no-underline outline-none focus:shadow-md">
                        <Link href="/manga">
                          <div className="mb-2 mt-4 text-lg font-medium">{category.title} Collection</div>
                          <p className="text-sm leading-tight text-muted-foreground">
                            Discover Japanese comics across all genres from action to romance.
                          </p>
                        </Link>
                      </div>
                    </NavigationMenuLink>
                  </li>
                </ul>
              </NavigationMenuContent>
            </NavigationMenuItem>
          ))}

          {/* Ereaders */}
          {navigationItems.filter(item => item.title === "Ereaders").map((category) => (
            <NavigationMenuItem key={category.title}>
              <NavigationMenuTrigger className="bg-transparent font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent className="backdrop-blur-sm bg-accent/80 border border-border">
                <ul className="grid w-[400px] gap-3 p-4 md:w-[500px] md:grid-cols-2 lg:w-[500px]">
                  {ereaderCategories.map((section) => (
                    <li key={section.title} className="row-span-1">
                      <NavigationMenuLink asChild>
                        <div className="flex h-full w-full flex-col">
                          <h3 className="text-sm font-medium text-secondary">
                            {section.title}
                          </h3>
                          <ul className="mt-2 space-y-2">
                            {section.items.map((item) => (
                              <li key={item.title}>
                                <Link
                                  href={item.href}
                                  className="block rounded-md p-2 text-sm font-medium text-muted-foreground hover:bg-accent hover:text-secondary transition-colors"
                                >
                                  {item.title}
                                </Link>
                              </li>
                            ))}
                          </ul>
                        </div>
                      </NavigationMenuLink>
                    </li>
                  ))}
                  <li className="row-span-2">
                    <NavigationMenuLink asChild>
                      <div className="flex h-full w-full flex-col justify-end rounded-md bg-gradient-to-b from-muted/50 to-muted p-6 no-underline outline-none focus:shadow-md">
                        <Link href="/ereaders">
                          <div className="mb-2 mt-4 text-lg font-medium">{category.title} Store</div>
                          <p className="text-sm leading-tight text-muted-foreground">
                            Shop the latest ereaders and accessories for your digital reading.
                          </p>
                        </Link>
                      </div>
                    </NavigationMenuLink>
                  </li>
                </ul>
              </NavigationMenuContent>
            </NavigationMenuItem>
          ))}
        </NavigationMenuList>
      </NavigationMenu>
    </div>
  );
}
