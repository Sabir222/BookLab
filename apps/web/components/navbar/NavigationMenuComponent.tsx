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

const bookCategories = [
  { title: "Book Categories" },
];

const dropdownSections = [
  {
    title: "Main Categories",
    items: [
      { title: "Fiction", href: "/category/fiction" },
      { title: "Non-Fiction", href: "/category/non-fiction" },
      { title: "Children Books", href: "/category/children-books" },
      { title: "Kids", href: "/category/kids" },
      { title: "Comics", href: "/category/comics" },
      { title: "Manga", href: "/category/manga" },
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

export function NavigationMenuComponent() {
  return (
    <div className="border-t border-border/50 pt-2">
      <NavigationMenu className="w-full">
        <NavigationMenuList>
          {bookCategories.map((category) => (
            <NavigationMenuItem key={category.title}>
              <NavigationMenuTrigger className="bg-transparent font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent className="backdrop-blur-sm bg-accent/80 border border-border">
                <ul className="grid w-[600px] gap-3 p-4 md:w-[500px] md:grid-cols-3 lg:w-[600px]">
                  {dropdownSections.map((section) => (
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
        </NavigationMenuList>
      </NavigationMenu>
    </div>
  );
}
