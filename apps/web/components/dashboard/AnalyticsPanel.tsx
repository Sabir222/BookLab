"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { BarChart3 } from "lucide-react";

export function AnalyticsPanel() {
  return (
    <Card className="border border-border shadow-lg rounded-2xl overflow-hidden">
      <CardHeader className="bg-muted border-b border-border">
        <CardTitle className="flex items-center text-foreground">
          <BarChart3 className="w-5 h-5 mr-3 text-primary" />
          Analytics Overview
        </CardTitle>
      </CardHeader>
      <CardContent className="pt-8 pb-12">
        <div className="flex flex-col items-center justify-center">
          <div className="relative w-32 h-32 rounded-full bg-muted flex items-center justify-center mb-6">
            <BarChart3 className="w-12 h-12 text-muted-foreground" />
          </div>
          <h3 className="text-xl font-semibold text-foreground mb-2">Coming Soon!</h3>
          <p className="text-muted-foreground text-center max-w-md">
            Analytics dashboard with insights about your book collection
          </p>
        </div>
      </CardContent>
    </Card>
  );
}