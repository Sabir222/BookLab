"use client";

import { useState } from "react";
import { DashboardHeader } from "@/components/dashboard/DashboardHeader";
import { DashboardTabs } from "@/components/dashboard/DashboardTabs";
import { AnalyticsPanel } from "@/components/dashboard/AnalyticsPanel";
import { AddBookPanel } from "@/components/dashboard/AddBookPanel";
import { UsersPanel } from "@/components/dashboard/UsersPanel";
import { Tabs, TabsContent } from "@/components/ui/tabs";

export default function DashboardPage() {
  const [activeTab, setActiveTab] = useState("books");

  return (
    <div className="container mx-auto py-8">
      <DashboardHeader />
      
      <DashboardTabs activeTab={activeTab} onTabChange={setActiveTab} />
      
      <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
        <TabsContent value="analytics" className="mt-8">
          <AnalyticsPanel />
        </TabsContent>
        
        <TabsContent value="books" className="mt-8">
          <AddBookPanel />
        </TabsContent>
        
        <TabsContent value="users" className="mt-8">
          <UsersPanel />
        </TabsContent>
      </Tabs>
    </div>
  );
}
