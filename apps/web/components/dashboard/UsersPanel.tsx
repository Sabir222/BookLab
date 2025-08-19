"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Users } from "lucide-react";

export function UsersPanel() {
  return (
    <Card className="border border-border shadow-lg rounded-2xl overflow-hidden">
      <CardHeader className="bg-muted border-b border-border">
        <CardTitle className="flex items-center text-foreground">
          <Users className="w-5 h-5 mr-3 text-primary" />
          User Management
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-8 pb-12">
        <div className="flex flex-col items-center justify-center">
          <div className="relative w-32 h-32 rounded-full bg-muted flex items-center justify-center mb-6">
            <Users className="w-12 h-12 text-muted-foreground" />
          </div>
          <h3 className="text-xl font-semibold text-foreground mb-2">Coming Soon!</h3>
          <p className="text-muted-foreground text-center max-w-md">
            Manage users and permissions for your book collection
          </p>
        </div>
      </CardContent>
    </Card>
  );
}