import { Button } from "@/components/ui/button";
import { Bookmark } from "lucide-react";

interface WishlistButtonProps {
  isWishlisted?: boolean;
  onClick?: () => void;
  className?: string;
  size?: "default" | "sm" | "lg" | "icon";
}

export function WishlistButton({ isWishlisted = false, onClick, className = "", size = "icon" }: WishlistButtonProps) {
  return (
    <Button 
      variant="outline" 
      size={size}
      className={className}
      onClick={onClick}
    >
      <Bookmark className={`h-5 w-5 ${isWishlisted ? "fill-current text-red-500" : ""}`} />
    </Button>
  );
}