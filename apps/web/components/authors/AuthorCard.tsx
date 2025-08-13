import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { BookOpen, User } from "lucide-react";
import Link from "next/link";

interface Author {
  id: number;
  name: string;
  bio: string;
  bookCount: number;
  genres: string[];
  featured?: boolean;
}

interface AuthorCardProps {
  author: Author;
  variant?: "featured" | "default";
}

export function AuthorCard({ author, variant = "default" }: AuthorCardProps) {
  if (variant === "featured") {
    return (
      <Card key={author.id} className="overflow-hidden transition-all hover:shadow-lg">
        <CardHeader className="p-0">
          <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-48 flex items-center justify-center">
            <span className="text-5xl">✍️</span>
          </div>
        </CardHeader>
        <CardContent className="p-6">
          <CardTitle className="text-xl mb-2">{author.name}</CardTitle>
          <CardDescription className="mb-4 line-clamp-2">{author.bio}</CardDescription>
          <div className="flex flex-wrap gap-2 mb-4">
            {author.genres.slice(0, 3).map((genre) => (
              <Badge key={genre} variant="outline">
                {genre}
              </Badge>
            ))}
          </div>
          <div className="flex items-center justify-between">
            <div className="flex items-center text-sm text-muted-foreground">
              <BookOpen className="mr-1 h-4 w-4" />
              <span>{author.bookCount} books</span>
            </div>
            <Button asChild size="sm">
              <Link href={`/authors/${author.id}`}>View Profile</Link>
            </Button>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card key={author.id} className="transition-all hover:shadow-md">
      <CardHeader className="flex flex-row items-center gap-4">
        <div className="bg-gray-200 border-2 border-dashed rounded-xl w-16 h-16 flex items-center justify-center">
          <User className="h-8 w-8 text-gray-500" />
        </div>
        <div>
          <CardTitle className="text-lg">{author.name}</CardTitle>
          <div className="flex items-center text-sm text-muted-foreground mt-1">
            <BookOpen className="mr-1 h-4 w-4" />
            <span>{author.bookCount} books</span>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <p className="text-sm text-muted-foreground mb-3 line-clamp-2">{author.bio}</p>
        <div className="flex flex-wrap gap-2 mb-4">
          {author.genres.slice(0, 3).map((genre) => (
            <Badge key={genre} variant="secondary" className="text-xs">
              {genre}
            </Badge>
          ))}
        </div>
        <Button asChild variant="outline" size="sm" className="w-full">
          <Link href={`/authors/${author.id}`}>View Author Profile</Link>
        </Button>
      </CardContent>
    </Card>
  );
}