import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { MainLayout } from "@/components/MainLayout";
import { Toaster } from "@/components/ui/sonner";

const geistSans = Geist({
        variable: "--font-geist-sans",
        subsets: ["latin"],
});

const geistMono = Geist_Mono({
        variable: "--font-geist-mono",
        subsets: ["latin"],
});

export const metadata: Metadata = {
        title: "BookLab",
        description: "A bookstore for buying and renting books",
};

export default async function RootLayout({
        children,
}: Readonly<{
        children: React.ReactNode;
}>) {

        return (
                <html lang="en" suppressHydrationWarning>
                        <body
                                className={`${geistSans.variable} ${geistMono.variable} antialiased`}
                        >
                                <div className="bg-yellow-500 text-black text-center py-2 px-4 font-bold">
                                        ⚠️ This frontend is only 40% complete and is for backend testing purposes only ⚠️
                                </div>
                                <MainLayout>{children}</MainLayout>
                                <Toaster richColors />
                        </body>
                </html>
        );
}
