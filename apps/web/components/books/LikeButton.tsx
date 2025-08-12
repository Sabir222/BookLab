import { Button } from "@/components/ui/button";
import { Heart } from "lucide-react";

interface LikeButtonProps {
  isLiked?: boolean;
  onClick?: () => void;
  className?: string;
  size?: "default" | "sm" | "lg" | "icon";
}

export function LikeButton({ isLiked = false, onClick, className = "", size = "icon" }: LikeButtonProps) {
  return (
    <Button 
      variant="outline" 
      size={size}
      className={className}
      onClick={onClick}
    >
      <Heart className={`h-5 w-5 ${isLiked ? "fill-current" : ""}`} />
    </Button>
  );
}