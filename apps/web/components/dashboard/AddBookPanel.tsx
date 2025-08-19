"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BookOpen } from "lucide-react";
import { AddBookForm } from "./AddBookForm";

export function AddBookPanel() {
  return (
    <Card className="border border-border shadow-lg rounded-2xl overflow-hidden">
      <CardHeader className="bg-muted border-b border-border">
        <CardTitle className="flex items-center text-foreground">
          <BookOpen className="w-5 h-5 mr-3 text-primary" />
          Add New Book
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-6">
        <AddBookForm />
      </CardContent>
    </Card>
  );
}