import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";
import { MainLayout } from "@/components/MainLayout";

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
                                <MainLayout>{children}</MainLayout>
                        </body>
                </html>
        );
}
