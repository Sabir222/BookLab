import { Input } from "@/components/ui/input";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { User } from "lucide-react";
import { AuthorCard } from "@/components/authors/AuthorCard";

interface Author {
  id: number;
  name: string;
  bio: string;
  bookCount: number;
  genres: string[];
  featured?: boolean;
}

interface BrowseAuthorsSectionProps {
  allAuthors: Author[];
  popularGenres: string[];
}

export function BrowseAuthorsSection({ allAuthors, popularGenres }: BrowseAuthorsSectionProps) {
  return (
    <section>
      <div className="text-center mb-8">
        <h2 className="text-2xl font-semibold mb-4">Browse Authors</h2>
        <div className="flex flex-col sm:flex-row gap-2 justify-center max-w-md mx-auto">
          <div className="relative w-full">
            <div className="absolute left-2.5 top-2.5 h-4 w-4 text-muted-foreground">
              {/* Search icon will be added here if needed */}
            </div>
            <Input
              placeholder="Search authors..."
              className="pl-8"
            />
          </div>
          <Select defaultValue="all">
            <SelectTrigger className="w-full">
              <SelectValue placeholder="Filter by genre" />
            </SelectTrigger>
            <SelectContent>
              {popularGenres.map((genre) => (
                <SelectItem key={genre} value={genre.toLowerCase().replace(" ", "-")}>
                  {genre}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>
      </div>

      <Tabs defaultValue="all" className="w-full">
        <div className="flex justify-center mb-6">
          <TabsList className="bg-accent p-1">
            <TabsTrigger 
              value="all" 
              className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
            >
              All Authors
            </TabsTrigger>
            <TabsTrigger 
              value="popular" 
              className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
            >
              Popular
            </TabsTrigger>
            <TabsTrigger 
              value="new" 
              className="data-[state=active]:bg-primary data-[state=active]:text-primary-foreground"
            >
              New Authors
            </TabsTrigger>
          </TabsList>
        </div>
        <TabsContent value="all">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {allAuthors.map((author) => (
              <AuthorCard key={author.id} author={author} variant="default" />
            ))}
          </div>
        </TabsContent>
        <TabsContent value="popular">
          <div className="text-center py-12">
            <User className="mx-auto h-12 w-12 text-muted-foreground" />
            <h3 className="mt-4 text-lg font-medium">Popular Authors</h3>
            <p className="mt-2 text-muted-foreground max-w-md mx-auto">
              This section will show our most popular authors based on reader engagement.
            </p>
          </div>
        </TabsContent>
        <TabsContent value="new">
          <div className="text-center py-12">
            <User className="mx-auto h-12 w-12 text-muted-foreground" />
            <h3 className="mt-4 text-lg font-medium">New Authors</h3>
            <p className="mt-2 text-muted-foreground max-w-md mx-auto">
              Discover our newest authors who have recently joined our platform.
            </p>
          </div>
        </TabsContent>
      </Tabs>
    </section>
  );
}