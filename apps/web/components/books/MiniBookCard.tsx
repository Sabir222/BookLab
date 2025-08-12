import Link from "next/link";
import { useNavbarStore } from "@/components/navbar/navbarStore";

interface MiniBookCardProps {
  id: string;
  title: string;
  author: string;
  className?: string;
}

export function MiniBookCard({ id, title, author, className = "" }: MiniBookCardProps) {
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
      <div className="mt-0.5 text-muted-foreground">
        <span className="text-sm">📚</span>
      </div>
      <div>
        <div className="font-medium text-sm line-clamp-1">{title}</div>
        <div className="text-xs text-muted-foreground mt-1 line-clamp-1">{author}</div>
      </div>
    </Link>
  );
}
