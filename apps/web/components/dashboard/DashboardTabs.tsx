"use client";

import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";

interface DashboardTabsProps {
  activeTab: string;
  onTabChange: (value: string) => void;
}

export function DashboardTabs({ activeTab, onTabChange }: DashboardTabsProps) {
  return (
    <Tabs value={activeTab} onValueChange={onTabChange} className="w-full">
      <TabsList className="w-full justify-start bg-background rounded-none border-b border-border p-0 h-12">
        <TabsTrigger 
          value="analytics" 
          className="data-[state=active]:bg-transparent data-[state=active]:text-foreground data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none h-12 px-4"
        >
          Analytics
        </TabsTrigger>
        <TabsTrigger 
          value="books" 
          className="data-[state=active]:bg-transparent data-[state=active]:text-foreground data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none h-12 px-4"
        >
          Add Book
        </TabsTrigger>
        <TabsTrigger 
          value="users" 
          className="data-[state=active]:bg-transparent data-[state=active]:text-foreground data-[state=active]:border-b-2 data-[state=active]:border-primary rounded-none h-12 px-4"
        >
          Manage Users
        </TabsTrigger>
      </TabsList>
    </Tabs>
  );
}