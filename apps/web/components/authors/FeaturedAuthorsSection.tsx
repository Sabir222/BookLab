import { Button } from "@/components/ui/button";
import { AuthorCard } from "@/components/authors/AuthorCard";

interface Author {
  id: number;
  name: string;
  bio: string;
  bookCount: number;
  genres: string[];
  featured?: boolean;
}

interface FeaturedAuthorsSectionProps {
  featuredAuthors: Author[];
}

export function FeaturedAuthorsSection({ featuredAuthors }: FeaturedAuthorsSectionProps) {
  return (
    <section className="mb-16">
      <div className="text-center mb-8">
        <h2 className="text-2xl font-semibold mb-2">Featured Authors</h2>
        <Button variant="link" className="text-primary hover:text-primary/80">
          View All
        </Button>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {featuredAuthors.map((author) => (
          <AuthorCard key={author.id} author={author} variant="featured" />
        ))}
      </div>
    </section>
  );
}