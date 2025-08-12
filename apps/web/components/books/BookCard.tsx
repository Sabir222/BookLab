import Link from "next/link";
import { Button } from "@/components/ui/button";
import { WishlistButton } from "@/components/books/LikeButton";

interface BookCardProps {
        id: string;
        title: string;
        author: string;
        price: number;
        className?: string;
}

export function BookCard({ id, title, author, price, className = "" }: BookCardProps) {
        return (
                <div className={`border border-border rounded-lg p-4 hover:bg-accent transition-colors duration-200 flex flex-col ${className}`}>
                        <Link href={`/book/${id}`} className="flex-grow">
                                <div className="bg-gray-200 border-2 border-dashed rounded-xl w-full h-48 flex items-center justify-center">
                                        <span className="text-3xl">📚</span>
                                </div>
                                <h2 className="font-semibold text-primary mt-4 line-clamp-2">{title}</h2>
                                <p className="text-muted-foreground text-sm mt-1">{author}</p>
                                <p className="font-medium text-primary mt-2">${price.toFixed(2)}</p>
                        </Link>
                        <div className="flex gap-2 mt-4">
                                <Button className="flex-1" size="sm">Add to Cart</Button>
                                <WishlistButton className="h-8 w-8" />
                        </div>
                </div>
        );
}
