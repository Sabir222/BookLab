"use client";

import { BookWithDetails } from "@repo/types/types";

interface ReviewsProps {
  book: BookWithDetails;
}

export function Reviews({ book }: ReviewsProps) {
  return (
    <div className="mt-12">
      <h2 className="text-2xl font-bold text-primary mb-6">Customer Reviews</h2>
      
      {book.total_reviews > 0 ? (
        <div className="space-y-6">
          <p>Reviews are coming soon. Be the first to review this product!</p>
        </div>
      ) : (
        <div className="text-center py-12">
          <div className="bg-muted rounded-lg p-8 max-w-md mx-auto">
            <h3 className="text-xl font-semibold mb-2">No reviews yet</h3>
            <p className="text-muted-foreground mb-4">Be the first to share your experience with this book!</p>
            <button className="px-4 py-2 bg-primary text-primary-foreground rounded-md hover:bg-primary/90 transition-colors">
              Write a Review
            </button>
          </div>
        </div>
      )}
    </div>
  );
}