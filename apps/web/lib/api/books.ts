"use client";

import { Book } from "@repo/types/types";
import { ApiResponse } from "@/types";
import fetchWithRefresh from "../fetchWithRefresh";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:3001";

export interface BookWithAuthor extends Book {
  author_name?: string;
}

export const bookApi = {
  async getBookById(bookId: string): Promise<BookWithAuthor | null> {
    try {
      const response = await fetchWithRefresh(
        `${API_BASE_URL}/api/books/${bookId}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        },
      );

      if (!response.ok) {
        throw new Error(`Failed to fetch book: ${response.status}`);
      }

      const result: ApiResponse<{ book: BookWithAuthor }> =
        await response.json();
      return result.data?.book || null;
    } catch (error) {
      console.error("Error fetching book:", error);
      return null;
    }
  },

  async getRelatedBooks(bookId: string): Promise<BookWithAuthor[]> {
    try {
      const response = await fetchWithRefresh(
        `${API_BASE_URL}/api/books/${bookId}/related`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        },
      );

      if (!response.ok) {
        throw new Error(`Failed to fetch related books: ${response.status}`);
      }

      const result: ApiResponse<{ books: BookWithAuthor[] }> =
        await response.json();
      return result.data?.books || [];
    } catch (error) {
      console.error("Error fetching related books:", error);
      return [];
    }
  },

  async createBook(bookData: any): Promise<Book> {
    const response = await fetchWithRefresh(`${API_BASE_URL}/api/books`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(bookData),
    });

    if (!response.ok) {
      throw new Error("Failed to create book");
    }

    return response.json();
  },
};

