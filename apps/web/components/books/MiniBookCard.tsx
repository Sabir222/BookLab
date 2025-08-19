import Link from "next/link";
import { useNavbarStore } from "@/components/navbar/navbarStore";
import Image from "next/image";

interface MiniBookCardProps {
  id: string;
  title: string;
  author: string;
  coverImage?: string;
  className?: string;
}

export function MiniBookCard({ id, title, author, coverImage, className = "" }: MiniBookCardProps) {
  const { closeSearch } = useNavbarStore();

  const handleClick = () => {
    closeSearch();
  };

  return (
    <Link
      href={`/book/${id}`}
      className={`flex items-start gap-2 p-2 hover:bg-accent transition-colors duration-150 rounded ${className}`}
      onClick={handleClick}
    >
      {coverImage ? (
        <div className="mt-0.5 flex-shrink-0">
          <div className="relative w-8 h-10 rounded-sm overflow-hidden">
            <Image
              src={coverImage}
              alt={title}
              fill
              className="object-cover"
              sizes="32px"
            />
          </div>
        </div>
      ) : (
        <div className="mt-0.5 text-muted-foreground flex-shrink-0">
          <span className="text-sm">📚</span>
        </div>
      )}
      <div className="min-w-0">
        <div className="font-medium text-sm line-clamp-1">{title}</div>
        <div className="text-xs text-muted-foreground mt-1 line-clamp-1">{author}</div>
      </div>
    </Link>
  );
}
