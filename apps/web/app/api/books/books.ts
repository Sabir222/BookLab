import { Book, BookWithDetails } from "@repo/types/types";
import { ApiResponse } from "@/types";
import fetchWithRefresh from "@/lib/fetchWithRefresh";

const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:3001";

export const bookApi = {
  async getBooksTest(): Promise<BookWithDetails[]> {
    const res = await fetchWithRefresh(
      `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/books`,
      {
        cache: "no-store",
      },
    );
    if (!res.ok) {
      throw new Error("Failed to fetch books");
    }
    const json: ApiResponse<{ books: BookWithDetails[] }> = await res.json();
    if (!json.success || !json.data) {
      throw new Error(json.error ?? "Unknown error");
    }
    return json.data.books;
  },
  async getNewReleases(limit: number = 10): Promise<BookWithDetails[]> {
    try {
      const response = await fetchWithRefresh(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/books/new-releases?limit=${limit}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        },
      );

      if (!response.ok) {
        throw new Error(`Failed to fetch new releases: ${response.status}`);
      }

      const result: ApiResponse<{ books: BookWithDetails[] }> =
        await response.json();
      return result.data?.books || [];
    } catch (error) {
      console.error("Error fetching new releases:", error);
      return [];
    }
  },
  async getTopRatedBooks(limit: number = 10): Promise<BookWithDetails[]> {
    try {
      const response = await fetchWithRefresh(
        `${process.env.NEXT_PUBLIC_API_BASE_URL}/api/books/top-rated?limit=${limit}`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        },
      );

      if (!response.ok) {
        throw new Error(`Failed to fetch top rated books: ${response.status}`);
      }

      const result: ApiResponse<{ books: BookWithDetails[] }> =
        await response.json();
      return result.data?.books || [];
    } catch (error) {
      console.error("Error fetching top rated books:", error);
      return [];
    }
  },

  async getBookById(bookId: string): Promise<BookWithDetails | null> {
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

      const result: ApiResponse<{ book: BookWithDetails }> =
        await response.json();
      return result.data?.book || null;
    } catch (error) {
      console.error("Error fetching book:", error);
      return null;
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
