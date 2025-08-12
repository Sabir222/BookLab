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
  { title: "Fiction" },
  { title: "Non-Fiction" },
  { title: "History" },
  { title: "Popular Genres" },
];

const dropdownSections = [
  {
    title: "New Arrivals",
    items: [
      { title: "Latest Fantasy Releases", href: "/new/fantasy" },
      { title: "New Mystery Thrillers", href: "/new/mystery" },
      { title: "Hot Nonfiction Picks", href: "/new/nonfiction" },
    ]
  },
  {
    title: "Top Categories / Genres",
    items: [
      { title: "Bestsellers", href: "/bestsellers" },
      { title: "Award-Winning Books", href: "/awards" },
      { title: "Trending on BookTok", href: "/trending" },
    ]
  },
  {
    title: "Kids & Teens (Discover Section)",
    items: [
      { title: "Children's Picture Books", href: "/kids/picture-books" },
      { title: "Middle Grade Adventures", href: "/kids/middle-grade" },
      { title: "Teen Fantasy & Romance", href: "/teens/fantasy-romance" },
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
              <NavigationMenuTrigger className="font-medium text-sm hover:text-secondary data-[state=open]:text-secondary">
                {category.title}
              </NavigationMenuTrigger>
              <NavigationMenuContent>
                <ul className="grid w-[600px] gap-3 p-4 md:w-[500px] md:grid-cols-3 lg:w-[600px]">
                  {dropdownSections.map((section) => (
                    <li key={section.title} className="row-span-3">
                      <NavigationMenuLink asChild>
                        <div className="flex h-full w-full flex-col">
                          <h3 className={cn(
                            "text-sm font-medium",
                            section.title.includes("Discover")
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