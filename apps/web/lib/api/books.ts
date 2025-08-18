// @ts-nocheck
"use client";

import { Book } from "@repo/types/types";

const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || "http://localhost:3001";

export const bookApi = {
  async createBook(bookData: any): Promise<Book> {
    const response = await fetch(`${API_BASE_URL}/api/books`, {
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