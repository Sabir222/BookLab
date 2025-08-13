import { Button } from "@/components/ui/button";
import Link from "next/link";
import Image from "next/image";

export function MangaPromoSection() {
        return (
                <section className="w-full py-12 md:py-16">
                        <div className="container mx-auto px-4">
                                <div className="rounded-2xl p-8 md:p-12 overflow-hidden" style={{ backgroundColor: "#F8F4E9" }}>
                                        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                                                <div className="flex flex-col justify-center">
                                                        <div className="space-y-4">
                                                                <div className="inline-block bg-red-500 text-white text-xs font-bold px-3 py-1 rounded-full">
                                                                        NEW COLLECTION
                                                                </div>
                                                                <h2 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl text-gray-900">
                                                                        Discover the World of Manga
                                                                </h2>
                                                                <p className="max-w-[600px] text-gray-700 md:text-lg">
                                                                        Immerse yourself in captivating stories and stunning artwork. From action-packed adventures to heartwarming romances, our manga collection has something for every reader.
                                                                </p>
                                                                <ul className="space-y-2 text-gray-700">

                                                                        <li className="flex items-center">
                                                                                <span className="text-red-500 mr-2">✓</span>
                                                                                <span>Bestselling series and hidden gems</span>
                                                                        </li>
                                                                        <li className="flex items-center">
                                                                                <span className="text-red-500 mr-2">✓</span>
                                                                                <span>Original Japanese versions and translations</span>
                                                                        </li>
                                                                </ul>
                                                                <div className="flex flex-col sm:flex-row gap-4 pt-4">
                                                                        <Button asChild size="lg" className="bg-red-500 text-white hover:bg-red-600">
                                                                                <Link href="/books?category=manga">Explore Manga Collection</Link>
                                                                        </Button>
                                                                </div>
                                                        </div>
                                                </div>

                                                <div className="flex justify-center">
                                                        <div className="relative w-full max-w-md">
                                                                <div className="relative w-full h-80 md:h-96">
                                                                        <Image
                                                                                src="/manga.png"
                                                                                alt="Manga collection"
                                                                                fill
                                                                                className="object-contain"
                                                                                priority
                                                                        />
                                                                </div>
                                                        </div>
                                                </div>
                                        </div>
                                </div>
                        </div>
                </section>
        );
}
