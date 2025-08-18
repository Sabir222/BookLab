"use client";

import { useState } from "react";
import { format } from "date-fns";
import { Tabs, TabsList, TabsTrigger, TabsContent } from "@/components/ui/tabs";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import {
        Select,
        SelectContent,
        SelectItem,
        SelectTrigger,
        SelectValue
} from "@/components/ui/select";
import { Switch } from "@/components/ui/switch";
import { Checkbox } from "@/components/ui/checkbox";
import { Calendar } from "@/components/ui/calendar";
import {
        Popover,
        PopoverContent,
        PopoverTrigger,
} from "@/components/ui/popover";
import { ChevronDownIcon } from "lucide-react";
import { bookApi } from "@/lib/api/books";
import { showToast } from "@/lib/toast";

// Categories data from database
const categories = [
        { id: "9afa3511-0ba6-4c66-b2f2-169c6815d139", name: "Fiction" },
        { id: "0ed7950e-5e69-4aac-b67d-d426d8ead6fe", name: "Non-Fiction" },
        { id: "17739b35-27cb-41af-bb8d-d996f3519ee7", name: "Science Fiction" },
        { id: "43f85820-0294-49e4-953c-ea119f2eb8f9", name: "Fantasy" },
        { id: "df3f99de-178a-4afb-8d5b-1e4b1baa42c2", name: "Mystery" },
        { id: "84484d09-8b66-4ea7-9edc-106fd13ffd73", name: "Romance" },
        { id: "ec0889c4-d73c-4fd6-bdc1-2019b30354f4", name: "Biography" },
        { id: "9d63c60f-7d13-44cb-9c19-441065e52970", name: "History" },
        { id: "6f658bbf-f7ec-4e3c-a308-14508f6f0227", name: "Science" },
        { id: "16d30dff-9a95-4782-b291-6f8b94de161f", name: "Self-Help" },
        { id: "7d26a24b-ae3b-49bb-9548-1018a5c2fee3", name: "Comics" },
        { id: "7714415f-2a2c-4c93-b573-c8636f2c43f1", name: "Kids" },
        { id: "976f1dbf-8f7e-47b1-963e-1248dc8878da", name: "Literary Fiction" },
        { id: "0b4c28ac-7736-4224-96af-e0fbe31bfd1b", name: "Thriller" },
        { id: "6a151e20-73d9-45e0-94bf-be7a0f73f4cf", name: "Horror" },
        { id: "7a6b9d3b-dece-4c9b-bb09-9353b2162b4a", name: "Memoir" },
        { id: "3e0912eb-37da-4b7a-b2a1-957ce7880335", name: "Essays" },
        { id: "12a94927-a872-4f85-bb9c-18d1bd716733", name: "Travel" },
        { id: "fa7e1059-7a33-4976-8bbd-2e6189548642", name: "Space Opera" },
        { id: "2fdbc5bc-8d2d-44ff-a310-dd8935be5f92", name: "Cyberpunk" },
        { id: "7c78a105-695c-4a82-b99a-b4d0fdcb1915", name: "High Fantasy" },
        { id: "48505004-1f42-4e63-8239-97f58d28695f", name: "Urban Fantasy" },
        { id: "4eead143-9d1a-4833-983b-dc4db5423996", name: "Paranormal Romance" },
        { id: "e7a732e2-8fa5-404f-ad92-c6a8e74e4fd5", name: "Manga" },
        { id: "d93f78b4-ac63-42e7-9948-eeaf37454f94", name: "Picture Books" },
        { id: "813e9cc2-5251-49d4-bee0-a85fd21934f7", name: "Early Readers" },
];

// Genres data from database
const genres = [
        { id: "f250adc5-8454-4ed3-81ff-dbde4c78bd1f", name: "Adventure" },
        { id: "66eb7658-e0ec-42f2-81e5-dbf2fae92a7a", name: "Comics" },
        { id: "bf3da532-c2f1-412f-9ec1-00bef471b602", name: "Dystopian" },
        { id: "5c1074cd-d714-4d26-9612-e3b7cd658012", name: "Epic Fantasy" },
        { id: "fa20b252-7783-4d1b-ad94-32105fe66f65", name: "Historical Fiction" },
        { id: "e88a4263-f077-4766-bcdf-1b7c585d211b", name: "Horror" },
        { id: "805dcfc3-1e6a-438a-99dc-ba561122d404", name: "Humor" },
        { id: "e1ab905f-081f-4a7d-af4e-deabbd543583", name: "Magical Realism" },
        { id: "d593ca2c-74ac-404a-af1b-52f38f7f325b", name: "Manga" },
        { id: "1e2f9b36-f664-4981-89a4-181aaee35eec", name: "Noir" },
        { id: "9ae1fac3-0fd2-475e-bdfb-a916296450f1", name: "Romance" },
        { id: "68e2ff8f-6716-4de9-99cf-990050bc8f92", name: "Science Fiction" },
        { id: "90923e17-feac-40d3-b71a-765b15dbc600", name: "Steampunk" },
        { id: "202f2f51-ada8-430d-82e0-69c842374693", name: "Superhero" },
        { id: "d9f01075-d55c-4023-ba92-8dc49a70f976", name: "Urban Fantasy" },
        { id: "266310e8-0287-41e8-b5b0-fd0e237d438f", name: "Young Adult" },
        { id: "a7010a6c-d6e8-4003-887f-f6298c65c147", name: "Zombie Apocalypse" },
        { id: "19c3f489-1c50-442f-886d-0c12b920843f", name: "Hard Science Fiction" },
        { id: "24b6f710-3aef-4366-946b-e96c4ab9cee2", name: "Space Opera" },
        { id: "281180bb-22f5-4d70-ad6e-1ef83ac4075f", name: "Space Western" },
        { id: "e24133c2-7389-4025-ac73-f115f2d4dd26", name: "Time Travel Romance" },
        { id: "a0482b48-0021-4379-9f87-f33fdea112d5", name: "Dark Fantasy" },
        { id: "11210297-4c99-4591-91af-523b7a12cdb3", name: "Gothic Fiction" },
        { id: "01d76067-7374-4d66-98a8-1dbb54b9b23a", name: "Shonen" },
        { id: "8cf9b6ad-3de3-4950-ac39-b7b21f29840e", name: "Shojo" },
        { id: "c0c8c831-40d8-4e4d-8034-bb0ab8b4c682", name: "Seinen" },
        { id: "2e0259ae-254f-4378-9761-53e3a3797cf0", name: "Josei" },
        { id: "34a002a9-a810-408e-abe7-f3c6dca0283f", name: "Superhero Comics" },
        { id: "62162227-45f3-444c-84b2-facde7d49fa1", name: "Indie Comics" },
        { id: "e2e54289-a55d-401a-a341-77e5b08023e0", name: "Coming-of-Age" },
];

// Admins data from database
const admins = [
        { id: "520fbff8-cd1e-4b14-a795-435d84e84c84", name: "rime" },
        { id: "ae56df41-0f6a-4214-b054-0d887be48d2b", name: "imam" },
        { id: "489e54e3-043d-4e2d-97a2-100ad4e2fec9", name: "sabir" },
];

const DashboardPage = () => {
        const [activeTab, setActiveTab] = useState("books");

        return (
                <div className="container mx-auto py-8">
                        <h1 className="text-3xl font-bold mb-8">Dashboard</h1>

                        <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
                                <TabsList className="grid w-full grid-cols-3">
                                        <TabsTrigger value="analytics" className="data-[state=active]:bg-white data-[state=active]:text-black dark:data-[state=active]:bg-gray-800 dark:data-[state=active]:text-white">Analytics</TabsTrigger>
                                        <TabsTrigger value="books" className="data-[state=active]:bg-white data-[state=active]:text-black dark:data-[state=active]:bg-gray-800 dark:data-[state=active]:text-white">Add Book</TabsTrigger>
                                        <TabsTrigger value="users" className="data-[state=active]:bg-white data-[state=active]:text-black dark:data-[state=active]:bg-gray-800 dark:data-[state=active]:text-white">Manage Users</TabsTrigger>
                                </TabsList>

                                <TabsContent value="analytics" className="mt-6">
                                        <Card>
                                                <CardHeader>
                                                        <CardTitle>Analytics Overview</CardTitle>
                                                </CardHeader>
                                                <CardContent>
                                                        <p>Analytics dashboard content will be implemented here.</p>
                                                </CardContent>
                                        </Card>
                                </TabsContent>

                                <TabsContent value="books" className="mt-6">
                                        <Card>
                                                <CardHeader>
                                                        <CardTitle>Add New Book</CardTitle>
                                                </CardHeader>
                                                <CardContent>
                                                        <AddBookForm />
                                                </CardContent>
                                        </Card>
                                </TabsContent>

                                <TabsContent value="users" className="mt-6">
                                        <Card>
                                                <CardHeader>
                                                        <CardTitle>User Management</CardTitle>
                                                </CardHeader>
                                                <CardContent>
                                                        <p>User management features will be implemented here.</p>
                                                </CardContent>
                                        </Card>
                                </TabsContent>
                        </Tabs>
                </div>
        );
};

const AddBookForm = () => {
        const [formData, setFormData] = useState({
                title: "",
                subtitle: "",
                description: "",
                isbn13: "",
                isbn10: "",
                publicationDate: undefined as Date | undefined,
                publishedYear: "",
                pageCount: "",
                language: "en",
                coverImageUrl: "",
                coverImageSmallUrl: "",
                coverImageMediumUrl: "",
                coverImageLargeUrl: "",
                edition: "",
                bookFormat: "paperback",
                bookCondition: "",
                dimensions: "",
                weightGrams: "",
                forSale: true,
                forRent: false,
                priceSale: "",
                priceRentDaily: "",
                priceRentWeekly: "",
                priceRentMonthly: "",
                stockQuantity: "0",
                reservedQuantity: "0",
                isActive: true,
                averageRating: "",
                totalRatings: "0",
                totalReviews: "0",
                publisherId: "",
                ownerId: "",
                primaryCategoryId: "",
                searchKeywords: "",
                slug: "",
                createdBy: "",
                lastModifiedBy: "",
        });

        // For category and genre selection
        const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
        const [selectedGenres, setSelectedGenres] = useState<string[]>([]);
        const [openCalendar, setOpenCalendar] = useState(false);

        const [isSubmitting, setIsSubmitting] = useState(false);

        const handleInputChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
                const { name, value } = e.target;
                setFormData(prev => ({ ...prev, [name]: value }));
        };

        const handleDateChange = (date: Date | undefined) => {
                setFormData(prev => ({ ...prev, publicationDate: date }));
        };

        const handleSelectChange = (name: string, value: string) => {
                setFormData(prev => ({ ...prev, [name]: value }));
        };

        const handleSwitchChange = (name: string, checked: boolean) => {
                setFormData(prev => ({ ...prev, [name]: checked }));
        };

        const handleCategoryChange = (categoryId: string, isPrimary: boolean = false) => {
                if (isPrimary) {
                        setFormData(prev => ({ ...prev, primaryCategoryId: categoryId }));
                } else {
                        setSelectedCategories(prev =>
                                prev.includes(categoryId)
                                        ? prev.filter(id => id !== categoryId)
                                        : [...prev, categoryId]
                        );
                }
        };

        const handleGenreChange = (genreId: string) => {
                setSelectedGenres(prev =>
                        prev.includes(genreId)
                                ? prev.filter(id => id !== genreId)
                                : [...prev, genreId]
                );
        };

        const handleSubmit = async (e: React.FormEvent) => {
                e.preventDefault();

                // Basic validation
                if (!formData.title) {
                        showToast.error("Title is required");
                        return;
                }

                if (formData.forSale && !formData.priceSale) {
                        showToast.error("Price is required when book is for sale");
                        return;
                }

                setIsSubmitting(true);

                const bookData = {
                        title: formData.title,
                        subtitle: formData.subtitle || null,
                        description: formData.description || null,
                        isbn13: formData.isbn13 || null,
                        isbn10: formData.isbn10 || null,
                        publicationDate: formData.publicationDate ? formData.publicationDate.toISOString().split('T')[0] : null,
                        publishedYear: formData.publishedYear ? parseInt(formData.publishedYear) : null,
                        pageCount: formData.pageCount ? parseInt(formData.pageCount) : null,
                        language: formData.language || null,
                        coverImageUrl: formData.coverImageUrl || null,
                        coverImageSmallUrl: formData.coverImageSmallUrl || null,
                        coverImageMediumUrl: formData.coverImageMediumUrl || null,
                        coverImageLargeUrl: formData.coverImageLargeUrl || null,
                        edition: formData.edition || null,
                        bookFormat: formData.bookFormat,
                        bookCondition: formData.bookCondition || null,
                        dimensions: formData.dimensions || null,
                        weightGrams: formData.weightGrams ? parseInt(formData.weightGrams) : null,
                        forSale: formData.forSale,
                        forRent: formData.forRent,
                        priceSale: parseFloat(formData.priceSale) || 0,
                        priceRentDaily: formData.priceRentDaily ? parseFloat(formData.priceRentDaily) : null,
                        priceRentWeekly: formData.priceRentWeekly ? parseFloat(formData.priceRentWeekly) : null,
                        priceRentMonthly: formData.priceRentMonthly ? parseFloat(formData.priceRentMonthly) : null,
                        stockQuantity: parseInt(formData.stockQuantity) || 0,
                        reservedQuantity: parseInt(formData.reservedQuantity) || 0,
                        isActive: formData.isActive,
                        averageRating: formData.averageRating ? parseFloat(formData.averageRating) : null,
                        totalRatings: parseInt(formData.totalRatings) || 0,
                        totalReviews: parseInt(formData.totalReviews) || 0,
                        publisherId: formData.publisherId || null,
                        ownerId: formData.ownerId || null,
                        primaryCategoryId: formData.primaryCategoryId || null,
                        // Add selected categories and genres
                        categoryIds: selectedCategories.length > 0 ? selectedCategories : null,
                        genreIds: selectedGenres.length > 0 ? selectedGenres : null,
                        searchKeywords: formData.searchKeywords ? formData.searchKeywords.split(',').map(k => k.trim()).filter(k => k) : null,
                        slug: formData.slug,
                        createdBy: formData.createdBy || null,
                        lastModifiedBy: formData.lastModifiedBy || null,
                };

                try {
                        await bookApi.createBook(bookData);
                        showToast.success("Book created successfully!");
                        setFormData({
                                title: "",
                                subtitle: "",
                                description: "",
                                isbn13: "",
                                isbn10: "",
                                publicationDate: undefined,
                                publishedYear: "",
                                pageCount: "",
                                language: "en",
                                coverImageUrl: "",
                                coverImageSmallUrl: "",
                                coverImageMediumUrl: "",
                                coverImageLargeUrl: "",
                                edition: "",
                                bookFormat: "paperback",
                                bookCondition: "",
                                dimensions: "",
                                weightGrams: "",
                                forSale: true,
                                forRent: false,
                                priceSale: "",
                                priceRentDaily: "",
                                priceRentWeekly: "",
                                priceRentMonthly: "",
                                stockQuantity: "0",
                                reservedQuantity: "0",
                                isActive: true,
                                averageRating: "",
                                totalRatings: "0",
                                totalReviews: "0",
                                publisherId: "",
                                ownerId: "",
                                primaryCategoryId: "",
                                searchKeywords: "",
                                slug: "",
                                createdBy: "",
                                lastModifiedBy: "",
                        });
                        setSelectedCategories([]);
                        setSelectedGenres([]);
                } catch (error) {
                        console.error("Error creating book:", error);
                        showToast.error("Failed to create book. Please try again.");
                } finally {
                        setIsSubmitting(false);
                }
        };

        return (
                <form onSubmit={handleSubmit} className="space-y-6">
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div className="space-y-2">
                                        <Label htmlFor="title">Title *</Label>
                                        <Input
                                                id="title"
                                                name="title"
                                                value={formData.title}
                                                onChange={handleInputChange}
                                                required
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="subtitle">Subtitle</Label>
                                        <Input
                                                id="subtitle"
                                                name="subtitle"
                                                value={formData.subtitle}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2 md:col-span-2">
                                        <Label htmlFor="description">Description</Label>
                                        <Textarea
                                                id="description"
                                                name="description"
                                                value={formData.description}
                                                onChange={handleInputChange}
                                                rows={4}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="isbn13">ISBN-13</Label>
                                        <Input
                                                id="isbn13"
                                                name="isbn13"
                                                value={formData.isbn13}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="isbn10">ISBN-10</Label>
                                        <Input
                                                id="isbn10"
                                                name="isbn10"
                                                value={formData.isbn10}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="publicationDate">Publication Date</Label>
                                        <Popover open={openCalendar} onOpenChange={setOpenCalendar}>
                                                <PopoverTrigger asChild>
                                                        <Button
                                                                variant="outline"
                                                                className="w-full justify-between font-normal"
                                                        >
                                                                {formData.publicationDate ? (
                                                                        format(formData.publicationDate, "PPP")
                                                                ) : (
                                                                        <span>Select date</span>
                                                                )}
                                                                <ChevronDownIcon className="h-4 w-4 opacity-50" />
                                                        </Button>
                                                </PopoverTrigger>
                                                <PopoverContent className="w-auto overflow-hidden p-0" align="start">
                                                        <Calendar
                                                                mode="single"
                                                                selected={formData.publicationDate}
                                                                onSelect={(date) => {
                                                                        handleDateChange(date);
                                                                        setOpenCalendar(false);
                                                                }}
                                                                captionLayout="dropdown"
                                                                fromYear={1900}
                                                                toYear={new Date().getFullYear()}
                                                        />
                                                </PopoverContent>
                                        </Popover>
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="publishedYear">Published Year</Label>
                                        <Input
                                                id="publishedYear"
                                                name="publishedYear"
                                                type="number"
                                                value={formData.publishedYear}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="pageCount">Page Count</Label>
                                        <Input
                                                id="pageCount"
                                                name="pageCount"
                                                type="number"
                                                value={formData.pageCount}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="language">Language</Label>
                                        <Select name="language" value={formData.language} onValueChange={(value) => handleSelectChange("language", value)}>
                                                <SelectTrigger>
                                                        <SelectValue />
                                                </SelectTrigger>
                                                <SelectContent>
                                                        <SelectItem value="en">English</SelectItem>
                                                        <SelectItem value="es">Spanish</SelectItem>
                                                        <SelectItem value="fr">French</SelectItem>
                                                        <SelectItem value="de">German</SelectItem>
                                                </SelectContent>
                                        </Select>
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="coverImageUrl">Cover Image URL</Label>
                                        <Input
                                                id="coverImageUrl"
                                                name="coverImageUrl"
                                                value={formData.coverImageUrl}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="coverImageSmallUrl">Cover Image Small URL</Label>
                                        <Input
                                                id="coverImageSmallUrl"
                                                name="coverImageSmallUrl"
                                                value={formData.coverImageSmallUrl}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="coverImageMediumUrl">Cover Image Medium URL</Label>
                                        <Input
                                                id="coverImageMediumUrl"
                                                name="coverImageMediumUrl"
                                                value={formData.coverImageMediumUrl}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="coverImageLargeUrl">Cover Image Large URL</Label>
                                        <Input
                                                id="coverImageLargeUrl"
                                                name="coverImageLargeUrl"
                                                value={formData.coverImageLargeUrl}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="edition">Edition</Label>
                                        <Input
                                                id="edition"
                                                name="edition"
                                                value={formData.edition}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="bookFormat">Book Format</Label>
                                        <Select name="bookFormat" value={formData.bookFormat} onValueChange={(value) => handleSelectChange("bookFormat", value)}>
                                                <SelectTrigger>
                                                        <SelectValue />
                                                </SelectTrigger>
                                                <SelectContent>
                                                        <SelectItem value="hardcover">Hardcover</SelectItem>
                                                        <SelectItem value="paperback">Paperback</SelectItem>
                                                        <SelectItem value="ebook">E-book</SelectItem>
                                                        <SelectItem value="audiobook">Audiobook</SelectItem>
                                                </SelectContent>
                                        </Select>
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="bookCondition">Book Condition</Label>
                                        <Input
                                                id="bookCondition"
                                                name="bookCondition"
                                                value={formData.bookCondition}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="dimensions">Dimensions</Label>
                                        <Input
                                                id="dimensions"
                                                name="dimensions"
                                                value={formData.dimensions}
                                                onChange={handleInputChange}
                                                placeholder="e.g., 8.5 x 5.5 x 1.2 inches"
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="weightGrams">Weight (grams)</Label>
                                        <Input
                                                id="weightGrams"
                                                name="weightGrams"
                                                type="number"
                                                value={formData.weightGrams}
                                                onChange={handleInputChange}
                                        />
                                </div>

                                <div className="space-y-2">
                                        <Label htmlFor="slug">Slug</Label>
                                        <Input
                                                id="slug"
                                                name="slug"
                                                value={formData.slug}
                                                onChange={handleInputChange}
                                        />
                                </div>
                        </div>

                        <div className="border rounded-lg p-4">
                                <h3 className="font-medium mb-4">Availability & Pricing</h3>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div className="flex items-center space-x-2">
                                                <Switch
                                                        id="forSale"
                                                        checked={formData.forSale}
                                                        onCheckedChange={(checked) => handleSwitchChange("forSale", checked)}
                                                />
                                                <Label htmlFor="forSale">For Sale</Label>
                                        </div>

                                        <div className="flex items-center space-x-2">
                                                <Switch
                                                        id="forRent"
                                                        checked={formData.forRent}
                                                        onCheckedChange={(checked) => handleSwitchChange("forRent", checked)}
                                                />
                                                <Label htmlFor="forRent">For Rent</Label>
                                        </div>

                                        <div className="flex items-center space-x-2">
                                                <Switch
                                                        id="isActive"
                                                        checked={formData.isActive}
                                                        onCheckedChange={(checked) => handleSwitchChange("isActive", checked)}
                                                />
                                                <Label htmlFor="isActive">Is Active</Label>
                                        </div>

                                        {formData.forSale && (
                                                <div className="space-y-2">
                                                        <Label htmlFor="priceSale">Sale Price *</Label>
                                                        <Input
                                                                id="priceSale"
                                                                name="priceSale"
                                                                type="number"
                                                                step="0.01"
                                                                value={formData.priceSale}
                                                                onChange={handleInputChange}
                                                                required={formData.forSale}
                                                        />
                                                </div>
                                        )}

                                        {formData.forRent && (
                                                <>
                                                        <div className="space-y-2">
                                                                <Label htmlFor="priceRentDaily">Daily Rent Price</Label>
                                                                <Input
                                                                        id="priceRentDaily"
                                                                        name="priceRentDaily"
                                                                        type="number"
                                                                        step="0.01"
                                                                        value={formData.priceRentDaily}
                                                                        onChange={handleInputChange}
                                                                />
                                                        </div>

                                                        <div className="space-y-2">
                                                                <Label htmlFor="priceRentWeekly">Weekly Rent Price</Label>
                                                                <Input
                                                                        id="priceRentWeekly"
                                                                        name="priceRentWeekly"
                                                                        type="number"
                                                                        step="0.01"
                                                                        value={formData.priceRentWeekly}
                                                                        onChange={handleInputChange}
                                                                />
                                                        </div>

                                                        <div className="space-y-2">
                                                                <Label htmlFor="priceRentMonthly">Monthly Rent Price</Label>
                                                                <Input
                                                                        id="priceRentMonthly"
                                                                        name="priceRentMonthly"
                                                                        type="number"
                                                                        step="0.01"
                                                                        value={formData.priceRentMonthly}
                                                                        onChange={handleInputChange}
                                                                />
                                                        </div>
                                                </>
                                        )}

                                        <div className="space-y-2">
                                                <Label htmlFor="stockQuantity">Stock Quantity</Label>
                                                <Input
                                                        id="stockQuantity"
                                                        name="stockQuantity"
                                                        type="number"
                                                        value={formData.stockQuantity}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="reservedQuantity">Reserved Quantity</Label>
                                                <Input
                                                        id="reservedQuantity"
                                                        name="reservedQuantity"
                                                        type="number"
                                                        value={formData.reservedQuantity}
                                                        onChange={handleInputChange}
                                                />
                                        </div>
                                </div>
                        </div>

                        <div className="border rounded-lg p-4">
                                <h3 className="font-medium mb-4">Categories & Genres</h3>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        {/* Primary Category Selection - Only one can be selected */}
                                        <div className="space-y-2">
                                                <Label>Primary Category</Label>
                                                <div className="space-y-2 max-h-40 overflow-y-auto p-2 border rounded">
                                                        {categories.map((category) => (
                                                                <div key={category.id} className="flex items-center space-x-2">
                                                                        <Checkbox
                                                                                id={`primary-category-${category.id}`}
                                                                                checked={formData.primaryCategoryId === category.id}
                                                                                onCheckedChange={() => handleCategoryChange(category.id, true)}
                                                                        />
                                                                        <Label htmlFor={`primary-category-${category.id}`}>{category.name}</Label>
                                                                </div>
                                                        ))}
                                                </div>
                                        </div>

                                        {/* Other Categories Selection - Multiple can be selected */}
                                        <div className="space-y-2">
                                                <Label>Other Categories</Label>
                                                <div className="space-y-2 max-h-40 overflow-y-auto p-2 border rounded">
                                                        {categories.map((category) => (
                                                                <div key={category.id} className="flex items-center space-x-2">
                                                                        <Checkbox
                                                                                id={`category-${category.id}`}
                                                                                checked={selectedCategories.includes(category.id)}
                                                                                onCheckedChange={() => handleCategoryChange(category.id)}
                                                                        />
                                                                        <Label htmlFor={`category-${category.id}`}>{category.name}</Label>
                                                                </div>
                                                        ))}
                                                </div>
                                        </div>

                                        {/* Genres Selection - Multiple can be selected */}
                                        <div className="space-y-2 md:col-span-2">
                                                <Label>Genres</Label>
                                                <div className="space-y-2 max-h-40 overflow-y-auto p-2 border rounded">
                                                        {genres.map((genre) => (
                                                                <div key={genre.id} className="flex items-center space-x-2">
                                                                        <Checkbox
                                                                                id={`genre-${genre.id}`}
                                                                                checked={selectedGenres.includes(genre.id)}
                                                                                onCheckedChange={() => handleGenreChange(genre.id)}
                                                                        />
                                                                        <Label htmlFor={`genre-${genre.id}`}>{genre.name}</Label>
                                                                </div>
                                                        ))}
                                                </div>
                                        </div>
                                </div>
                        </div>

                        <div className="border rounded-lg p-4">
                                <h3 className="font-medium mb-4">Additional Information</h3>

                                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                                        <div className="space-y-2">
                                                <Label htmlFor="averageRating">Average Rating</Label>
                                                <Input
                                                        id="averageRating"
                                                        name="averageRating"
                                                        type="number"
                                                        step="0.1"
                                                        min="0"
                                                        max="5"
                                                        value={formData.averageRating}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="totalRatings">Total Ratings</Label>
                                                <Input
                                                        id="totalRatings"
                                                        name="totalRatings"
                                                        type="number"
                                                        value={formData.totalRatings}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="totalReviews">Total Reviews</Label>
                                                <Input
                                                        id="totalReviews"
                                                        name="totalReviews"
                                                        type="number"
                                                        value={formData.totalReviews}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="publisherId">Publisher ID</Label>
                                                <Input
                                                        id="publisherId"
                                                        name="publisherId"
                                                        value={formData.publisherId}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="ownerId">Owner ID</Label>
                                                <Input
                                                        id="ownerId"
                                                        name="ownerId"
                                                        value={formData.ownerId}
                                                        onChange={handleInputChange}
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="searchKeywords">Search Keywords</Label>
                                                <Input
                                                        id="searchKeywords"
                                                        name="searchKeywords"
                                                        value={formData.searchKeywords}
                                                        onChange={handleInputChange}
                                                        placeholder="Comma-separated keywords"
                                                />
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="createdBy">Created By</Label>
                                                <Select name="createdBy" value={formData.createdBy} onValueChange={(value) => handleSelectChange("createdBy", value)}>
                                                        <SelectTrigger>
                                                                <SelectValue placeholder="Select a user" />
                                                        </SelectTrigger>
                                                        <SelectContent>
                                                                {admins.map((admin) => (
                                                                        <SelectItem key={admin.id} value={admin.id}>
                                                                                {admin.name}
                                                                        </SelectItem>
                                                                ))}
                                                        </SelectContent>
                                                </Select>
                                        </div>

                                        <div className="space-y-2">
                                                <Label htmlFor="lastModifiedBy">Last Modified By</Label>
                                                <Select name="lastModifiedBy" value={formData.lastModifiedBy} onValueChange={(value) => handleSelectChange("lastModifiedBy", value)}>
                                                        <SelectTrigger>
                                                                <SelectValue placeholder="Select a user" />
                                                        </SelectTrigger>
                                                        <SelectContent>
                                                                {admins.map((admin) => (
                                                                        <SelectItem key={admin.id} value={admin.id}>
                                                                                {admin.name}
                                                                        </SelectItem>
                                                                ))}
                                                        </SelectContent>
                                                </Select>
                                        </div>
                                </div>
                        </div>

                        <div className="flex justify-end space-x-2">
                                <Button type="submit" disabled={isSubmitting}>
                                        {isSubmitting ? "Adding Book..." : "Add Book"}
                                </Button>
                                <Button type="button" variant="outline" onClick={() => {
                                        const previewSection = document.getElementById('preview-section');
                                        if (previewSection) {
                                                previewSection.scrollIntoView({ behavior: 'smooth' });
                                        }
                                }}>
                                        Preview Data
                                </Button>
                        </div>

                        <div id="preview-section" className="border rounded-lg p-4 mt-6 ">
                                <h3 className="font-medium mb-4 text-lg">Data Preview</h3>
                                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                                <h4 className="font-medium mb-2">Basic Information</h4>
                                                <div className="space-y-1 text-sm">
                                                        <p><span className="font-medium">Title:</span> {formData.title || "Not set"}</p>
                                                        <p><span className="font-medium">Subtitle:</span> {formData.subtitle || "Not set"}</p>
                                                        <p><span className="font-medium">Description:</span> {formData.description || "Not set"}</p>
                                                        <p><span className="font-medium">ISBN-13:</span> {formData.isbn13 || "Not set"}</p>
                                                        <p><span className="font-medium">ISBN-10:</span> {formData.isbn10 || "Not set"}</p>
                                                        <p><span className="font-medium">Publication Date:</span> {formData.publicationDate ? format(formData.publicationDate, "PPP") : "Not set"}</p>
                                                        <p><span className="font-medium">Published Year:</span> {formData.publishedYear || "Not set"}</p>
                                                        <p><span className="font-medium">Page Count:</span> {formData.pageCount || "Not set"}</p>
                                                        <p><span className="font-medium">Language:</span> {formData.language || "Not set"}</p>
                                                </div>
                                        </div>

                                        <div>
                                                <h4 className="font-medium mb-2">Pricing & Availability</h4>
                                                <div className="space-y-1 text-sm">
                                                        <p><span className="font-medium">For Sale:</span> {formData.forSale ? "Yes" : "No"}</p>
                                                        <p><span className="font-medium">For Rent:</span> {formData.forRent ? "Yes" : "No"}</p>
                                                        <p><span className="font-medium">Sale Price:</span> {formData.priceSale || "Not set"}</p>
                                                        {formData.forRent && (
                                                                <>
                                                                        <p><span className="font-medium">Daily Rent Price:</span> {formData.priceRentDaily || "Not set"}</p>
                                                                        <p><span className="font-medium">Weekly Rent Price:</span> {formData.priceRentWeekly || "Not set"}</p>
                                                                        <p><span className="font-medium">Monthly Rent Price:</span> {formData.priceRentMonthly || "Not set"}</p>
                                                                </>
                                                        )}
                                                        <p><span className="font-medium">Stock Quantity:</span> {formData.stockQuantity || "Not set"}</p>
                                                        <p><span className="font-medium">Reserved Quantity:</span> {formData.reservedQuantity || "Not set"}</p>
                                                        <p><span className="font-medium">Is Active:</span> {formData.isActive ? "Yes" : "No"}</p>
                                                </div>
                                        </div>

                                        <div>
                                                <h4 className="font-medium mb-2">Categories & Genres</h4>
                                                <div className="space-y-1 text-sm">
                                                        <p><span className="font-medium">Primary Category:</span> {
                                                                formData.primaryCategoryId
                                                                        ? categories.find(c => c.id === formData.primaryCategoryId)?.name || "Unknown"
                                                                        : "Not set"
                                                        }</p>
                                                        <p><span className="font-medium">Other Categories:</span> {
                                                                selectedCategories.length > 0
                                                                        ? selectedCategories.map(id => categories.find(c => c.id === id)?.name).filter(Boolean).join(", ") || "None"
                                                                        : "None"
                                                        }</p>
                                                        <p><span className="font-medium">Genres:</span> {
                                                                selectedGenres.length > 0
                                                                        ? selectedGenres.map(id => genres.find(g => g.id === id)?.name).filter(Boolean).join(", ") || "None"
                                                                        : "None"
                                                        }</p>
                                                </div>
                                        </div>

                                        <div>
                                                <h4 className="font-medium mb-2">Additional Information</h4>
                                                <div className="space-y-1 text-sm">
                                                        <p><span className="font-medium">Book Format:</span> {formData.bookFormat || "Not set"}</p>
                                                        <p><span className="font-medium">Book Condition:</span> {formData.bookCondition || "Not set"}</p>
                                                        <p><span className="font-medium">Edition:</span> {formData.edition || "Not set"}</p>
                                                        <p><span className="font-medium">Dimensions:</span> {formData.dimensions || "Not set"}</p>
                                                        <p><span className="font-medium">Weight (grams):</span> {formData.weightGrams || "Not set"}</p>
                                                        <p><span className="font-medium">Average Rating:</span> {formData.averageRating || "Not set"}</p>
                                                        <p><span className="font-medium">Total Ratings:</span> {formData.totalRatings || "Not set"}</p>
                                                        <p><span className="font-medium">Total Reviews:</span> {formData.totalReviews || "Not set"}</p>
                                                        <p><span className="font-medium">Publisher ID:</span> {formData.publisherId || "Not set"}</p>
                                                        <p><span className="font-medium">Owner ID:</span> {formData.ownerId || "Not set"}</p>
                                                        <p><span className="font-medium">Slug:</span> {formData.slug || "Not set"}</p>
                                                        <p><span className="font-medium">Search Keywords:</span> {formData.searchKeywords || "Not set"}</p>
                                                        <p><span className="font-medium">Created By:</span> {
                                                                formData.createdBy
                                                                        ? admins.find(a => a.id === formData.createdBy)?.name || "Unknown"
                                                                        : "Not set"
                                                        }</p>
                                                        <p><span className="font-medium">Last Modified By:</span> {
                                                                formData.lastModifiedBy
                                                                        ? admins.find(a => a.id === formData.lastModifiedBy)?.name || "Unknown"
                                                                        : "Not set"
                                                        }</p>
                                                </div>
                                        </div>
                                </div>
                        </div>
                </form>
        );
};

export default DashboardPage;
