import { FeaturedAuthorsSection } from "@/components/authors/FeaturedAuthorsSection";
import { BrowseAuthorsSection } from "@/components/authors/BrowseAuthorsSection";

// Mock data for authors
const featuredAuthors = [
  {
    id: 1,
    name: "Stephen King",
    bio: "American author of horror, supernatural fiction, suspense, crime, science-fiction, and fantasy novels.",
    bookCount: 64,
    genres: ["Horror", "Thriller", "Fantasy"],
    featured: true,
  },
  {
    id: 2,
    name: "J.K. Rowling",
    bio: "British author, best known for writing the Harry Potter fantasy series.",
    bookCount: 14,
    genres: ["Fantasy", "Young Adult", "Mystery"],
    featured: true,
  },
  {
    id: 3,
    name: "Agatha Christie",
    bio: "English writer known for her 66 detective novels and 14 short story collections.",
    bookCount: 77,
    genres: ["Mystery", "Crime", "Thriller"],
    featured: true,
  },
];

const allAuthors = [
  {
    id: 4,
    name: "George R.R. Martin",
    bio: "American novelist and short story writer, screenwriter, and television producer.",
    bookCount: 23,
    genres: ["Fantasy", "Science Fiction"],
  },
  {
    id: 5,
    name: "Margaret Atwood",
    bio: "Canadian poet, novelist, literary critic, essayist, teacher, environmental activist, and inventor.",
    bookCount: 52,
    genres: ["Dystopian", "Science Fiction", "Feminism"],
  },
  {
    id: 6,
    name: "Neil Gaiman",
    bio: "English author of short fiction, novels, comic books, graphic novels, audio theatre, and films.",
    bookCount: 38,
    genres: ["Fantasy", "Horror", "Comics"],
  },
  {
    id: 7,
    name: "Toni Morrison",
    bio: "American novelist, essayist, editor, teacher, and professor emeritus at Princeton University.",
    bookCount: 19,
    genres: ["Fiction", "Historical Fiction", "Literary Fiction"],
  },
  {
    id: 8,
    name: "Haruki Murakami",
    bio: "Japanese writer, whose books and stories have been bestsellers in Japan and internationally.",
    bookCount: 25,
    genres: ["Magical Realism", "Fiction", "Surrealism"],
  },
  {
    id: 9,
    name: "Isabel Allende",
    bio: "Chilean-American writer who has published 25 novels and 19 works of non-fiction.",
    bookCount: 31,
    genres: ["Magical Realism", "Historical Fiction", "Feminism"],
  },
];

const popularGenres = [
  "All Genres",
  "Fiction",
  "Non-Fiction",
  "Fantasy",
  "Mystery",
  "Romance",
  "Science Fiction",
  "Thriller",
  "Biography",
  "Historical Fiction",
  "Young Adult",
  "Horror",
  "Dystopian",
];

export default function AuthorsPage() {
  return (
    <div className="container px-4 lg:px-0 lg:mt-12 py-8 max-w-6xl mx-auto">
      <div className="text-center mb-12">
        <h1 className="text-3xl font-bold tracking-tight mb-2">Meet Our Authors</h1>
        <p className="text-muted-foreground max-w-2xl mx-auto">
          Discover talented writers and explore their literary works
        </p>
      </div>

      <FeaturedAuthorsSection featuredAuthors={featuredAuthors} />
      <BrowseAuthorsSection allAuthors={allAuthors} popularGenres={popularGenres} />
    </div>
  );
}
