"use client";

import { useState } from "react";
import { format } from "date-fns";
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
import { ChevronDownIcon, BookOpen, Eye, Library, Plus } from "lucide-react";
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

export function AddBookForm() {
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
    <form onSubmit={handleSubmit} className="space-y-8">
      {/* Basic Information Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <BookOpen className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Basic Information</h3>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <Label htmlFor="title" className="text-foreground">Title *</Label>
            <Input
              id="title"
              name="title"
              value={formData.title}
              onChange={handleInputChange}
              required
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="subtitle" className="text-foreground">Subtitle</Label>
            <Input
              id="subtitle"
              name="subtitle"
              value={formData.subtitle}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2 md:col-span-2">
            <Label htmlFor="description" className="text-foreground">Description</Label>
            <Textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleInputChange}
              rows={4}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="isbn13" className="text-foreground">ISBN-13</Label>
            <Input
              id="isbn13"
              name="isbn13"
              value={formData.isbn13}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="isbn10" className="text-foreground">ISBN-10</Label>
            <Input
              id="isbn10"
              name="isbn10"
              value={formData.isbn10}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="publicationDate" className="text-foreground">Publication Date</Label>
            <Popover open={openCalendar} onOpenChange={setOpenCalendar}>
              <PopoverTrigger asChild>
                <Button
                  variant="outline"
                  className="w-full justify-between font-normal border border-input hover:bg-accent rounded-lg"
                >
                  {formData.publicationDate ? (
                    format(formData.publicationDate, "PPP")
                  ) : (
                    <span className="text-muted-foreground">Select date</span>
                  )}
                  <ChevronDownIcon className="h-4 w-4 opacity-50" />
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-auto overflow-hidden p-0 rounded-lg shadow-lg" align="start">
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
            <Label htmlFor="publishedYear" className="text-foreground">Published Year</Label>
            <Input
              id="publishedYear"
              name="publishedYear"
              type="number"
              value={formData.publishedYear}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="pageCount" className="text-foreground">Page Count</Label>
            <Input
              id="pageCount"
              name="pageCount"
              type="number"
              value={formData.pageCount}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="language" className="text-foreground">Language</Label>
            <Select name="language" value={formData.language} onValueChange={(value) => handleSelectChange("language", value)}>
              <SelectTrigger className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg">
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
            <Label htmlFor="slug" className="text-foreground">Slug</Label>
            <Input
              id="slug"
              name="slug"
              value={formData.slug}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>
        </div>
      </div>

      {/* Media Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <Library className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Media</h3>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <Label htmlFor="coverImageUrl" className="text-foreground">Cover Image URL</Label>
            <Input
              id="coverImageUrl"
              name="coverImageUrl"
              value={formData.coverImageUrl}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="coverImageSmallUrl" className="text-foreground">Cover Image Small URL</Label>
            <Input
              id="coverImageSmallUrl"
              name="coverImageSmallUrl"
              value={formData.coverImageSmallUrl}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="coverImageMediumUrl" className="text-foreground">Cover Image Medium URL</Label>
            <Input
              id="coverImageMediumUrl"
              name="coverImageMediumUrl"
              value={formData.coverImageMediumUrl}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="coverImageLargeUrl" className="text-foreground">Cover Image Large URL</Label>
            <Input
              id="coverImageLargeUrl"
              name="coverImageLargeUrl"
              value={formData.coverImageLargeUrl}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>
        </div>
      </div>

      {/* Edition & Physical Details Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <BookOpen className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Edition & Physical Details</h3>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <Label htmlFor="edition" className="text-foreground">Edition</Label>
            <Input
              id="edition"
              name="edition"
              value={formData.edition}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="bookFormat" className="text-foreground">Book Format</Label>
            <Select name="bookFormat" value={formData.bookFormat} onValueChange={(value) => handleSelectChange("bookFormat", value)}>
              <SelectTrigger className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg">
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
            <Label htmlFor="bookCondition" className="text-foreground">Book Condition</Label>
            <Input
              id="bookCondition"
              name="bookCondition"
              value={formData.bookCondition}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="dimensions" className="text-foreground">Dimensions</Label>
            <Input
              id="dimensions"
              name="dimensions"
              value={formData.dimensions}
              onChange={handleInputChange}
              placeholder="e.g., 8.5 x 5.5 x 1.2 inches"
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="weightGrams" className="text-foreground">Weight (grams)</Label>
            <Input
              id="weightGrams"
              name="weightGrams"
              type="number"
              value={formData.weightGrams}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>
        </div>
      </div>

      {/* Availability & Pricing Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <Eye className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Availability & Pricing</h3>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          <div className="flex items-center justify-between p-4 bg-muted rounded-lg border border-border">
            <Label htmlFor="forSale" className="font-medium text-foreground">For Sale</Label>
            <Switch
              id="forSale"
              checked={formData.forSale}
              onCheckedChange={(checked) => handleSwitchChange("forSale", checked)}
              className="data-[state=checked]:bg-secondary"
            />
          </div>

          <div className="flex items-center justify-between p-4 bg-muted rounded-lg border border-border">
            <Label htmlFor="forRent" className="font-medium text-foreground">For Rent</Label>
            <Switch
              id="forRent"
              checked={formData.forRent}
              onCheckedChange={(checked) => handleSwitchChange("forRent", checked)}
              className="data-[state=checked]:bg-secondary"
            />
          </div>

          <div className="flex items-center justify-between p-4 bg-muted rounded-lg border border-border">
            <Label htmlFor="isActive" className="font-medium text-foreground">Is Active</Label>
            <Switch
              id="isActive"
              checked={formData.isActive}
              onCheckedChange={(checked) => handleSwitchChange("isActive", checked)}
              className="data-[state=checked]:bg-secondary"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {formData.forSale && (
            <div className="space-y-2">
              <Label htmlFor="priceSale" className="text-foreground">Sale Price *</Label>
              <Input
                id="priceSale"
                name="priceSale"
                type="number"
                step="0.01"
                value={formData.priceSale}
                onChange={handleInputChange}
                required={formData.forSale}
                className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
              />
            </div>
          )}

          {formData.forRent && (
            <>
              <div className="space-y-2">
                <Label htmlFor="priceRentDaily" className="text-foreground">Daily Rent Price</Label>
                <Input
                  id="priceRentDaily"
                  name="priceRentDaily"
                  type="number"
                  step="0.01"
                  value={formData.priceRentDaily}
                  onChange={handleInputChange}
                  className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="priceRentWeekly" className="text-foreground">Weekly Rent Price</Label>
                <Input
                  id="priceRentWeekly"
                  name="priceRentWeekly"
                  type="number"
                  step="0.01"
                  value={formData.priceRentWeekly}
                  onChange={handleInputChange}
                  className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="priceRentMonthly" className="text-foreground">Monthly Rent Price</Label>
                <Input
                  id="priceRentMonthly"
                  name="priceRentMonthly"
                  type="number"
                  step="0.01"
                  value={formData.priceRentMonthly}
                  onChange={handleInputChange}
                  className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
                />
              </div>
            </>
          )}

          <div className="space-y-2">
            <Label htmlFor="stockQuantity" className="text-foreground">Stock Quantity</Label>
            <Input
              id="stockQuantity"
              name="stockQuantity"
              type="number"
              value={formData.stockQuantity}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="reservedQuantity" className="text-foreground">Reserved Quantity</Label>
            <Input
              id="reservedQuantity"
              name="reservedQuantity"
              type="number"
              value={formData.reservedQuantity}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>
        </div>
      </div>

      {/* Categories & Genres Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <Library className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Categories & Genres</h3>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* Primary Category Selection - Only one can be selected */}
          <div className="space-y-2">
            <Label className="text-foreground">Primary Category</Label>
            <div className="space-y-2 max-h-60 overflow-y-auto p-3 border border-border rounded-lg bg-muted">
              {categories.map((category) => (
                <div 
                  key={category.id} 
                  className={`flex items-center space-x-3 p-2 rounded transition-colors cursor-pointer ${
                    formData.primaryCategoryId === category.id 
                      ? 'bg-secondary text-secondary-foreground' 
                      : 'hover:bg-accent'
                  }`}
                  onClick={() => handleCategoryChange(category.id, true)}
                >
                  <Checkbox
                    id={`primary-category-${category.id}`}
                    checked={formData.primaryCategoryId === category.id}
                    className="data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"
                  />
                  <Label 
                    htmlFor={`primary-category-${category.id}`} 
                    className={`font-normal cursor-pointer ${
                      formData.primaryCategoryId === category.id ? 'text-secondary-foreground' : 'text-foreground'
                    }`}
                  >
                    {category.name}
                  </Label>
                </div>
              ))}
            </div>
          </div>

          {/* Other Categories Selection - Multiple can be selected */}
          <div className="space-y-2">
            <Label className="text-foreground">Other Categories</Label>
            <div className="space-y-2 max-h-60 overflow-y-auto p-3 border border-border rounded-lg bg-muted">
              {categories.map((category) => (
                <div 
                  key={category.id} 
                  className={`flex items-center space-x-3 p-2 rounded transition-colors cursor-pointer ${
                    selectedCategories.includes(category.id) 
                      ? 'bg-secondary text-secondary-foreground' 
                      : 'hover:bg-accent'
                  }`}
                  onClick={() => handleCategoryChange(category.id)}
                >
                  <Checkbox
                    id={`category-${category.id}`}
                    checked={selectedCategories.includes(category.id)}
                    className="data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"
                  />
                  <Label 
                    htmlFor={`category-${category.id}`} 
                    className={`font-normal cursor-pointer ${
                      selectedCategories.includes(category.id) ? 'text-secondary-foreground' : 'text-foreground'
                    }`}
                  >
                    {category.name}
                  </Label>
                </div>
              ))}
            </div>
          </div>

          {/* Genres Selection - Multiple can be selected */}
          <div className="space-y-2">
            <Label className="text-foreground">Genres</Label>
            <div className="space-y-2 max-h-60 overflow-y-auto p-3 border border-border rounded-lg bg-muted">
              {genres.map((genre) => (
                <div 
                  key={genre.id} 
                  className={`flex items-center space-x-3 p-2 rounded transition-colors cursor-pointer ${
                    selectedGenres.includes(genre.id) 
                      ? 'bg-secondary text-secondary-foreground' 
                      : 'hover:bg-accent'
                  }`}
                  onClick={() => handleGenreChange(genre.id)}
                >
                  <Checkbox
                    id={`genre-${genre.id}`}
                    checked={selectedGenres.includes(genre.id)}
                    className="data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground"
                  />
                  <Label 
                    htmlFor={`genre-${genre.id}`} 
                    className={`font-normal cursor-pointer ${
                      selectedGenres.includes(genre.id) ? 'text-secondary-foreground' : 'text-foreground'
                    }`}
                  >
                    {genre.name}
                  </Label>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>

      {/* Additional Information Section */}
      <div className="bg-background rounded-xl p-6 border border-border shadow-sm">
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <BookOpen className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Additional Information</h3>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="space-y-2">
            <Label htmlFor="averageRating" className="text-foreground">Average Rating</Label>
            <Input
              id="averageRating"
              name="averageRating"
              type="number"
              step="0.1"
              min="0"
              max="5"
              value={formData.averageRating}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="totalRatings" className="text-foreground">Total Ratings</Label>
            <Input
              id="totalRatings"
              name="totalRatings"
              type="number"
              value={formData.totalRatings}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="totalReviews" className="text-foreground">Total Reviews</Label>
            <Input
              id="totalReviews"
              name="totalReviews"
              type="number"
              value={formData.totalReviews}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="publisherId" className="text-foreground">Publisher ID</Label>
            <Input
              id="publisherId"
              name="publisherId"
              value={formData.publisherId}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="ownerId" className="text-foreground">Owner ID</Label>
            <Input
              id="ownerId"
              name="ownerId"
              value={formData.ownerId}
              onChange={handleInputChange}
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="searchKeywords" className="text-foreground">Search Keywords</Label>
            <Input
              id="searchKeywords"
              name="searchKeywords"
              value={formData.searchKeywords}
              onChange={handleInputChange}
              placeholder="Comma-separated keywords"
              className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="createdBy" className="text-foreground">Created By</Label>
            <Select name="createdBy" value={formData.createdBy} onValueChange={(value) => handleSelectChange("createdBy", value)}>
              <SelectTrigger className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg">
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
            <Label htmlFor="lastModifiedBy" className="text-foreground">Last Modified By</Label>
            <Select name="lastModifiedBy" value={formData.lastModifiedBy} onValueChange={(value) => handleSelectChange("lastModifiedBy", value)}>
              <SelectTrigger className="border border-input focus:ring-2 focus:ring-ring focus:border-ring rounded-lg">
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

      {/* Action Buttons */}
      <div className="flex justify-end space-x-3 pt-6">
        <Button 
          type="submit" 
          disabled={isSubmitting}
          className="bg-secondary text-secondary-foreground hover:bg-secondary/90 font-medium py-2 px-4 rounded-lg shadow transition-all duration-200"
        >
          {isSubmitting ? (
            <>
              <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"></div>
              Adding Book...
            </>
          ) : (
            <>
              <Plus className="w-4 h-4 mr-2" />
              Add Book
            </>
          )}
        </Button>
        <Button 
          type="button" 
          variant="outline" 
          onClick={() => {
            const previewSection = document.getElementById('preview-section');
            if (previewSection) {
              previewSection.scrollIntoView({ behavior: 'smooth' });
            }
          }}
          className="border border-input bg-background text-foreground hover:bg-accent font-medium py-2 px-4 rounded-lg shadow transition-all duration-200"
        >
          <Eye className="w-4 h-4 mr-2" />
          Preview Data
        </Button>
      </div>

      {/* Data Preview Section */}
      <div 
        id="preview-section" 
        className="bg-background rounded-xl p-6 border border-border shadow-lg mt-8"
      >
        <div className="flex items-center mb-6">
          <div className="p-2 rounded-lg bg-muted mr-4">
            <Eye className="w-5 h-5 text-primary" />
          </div>
          <h3 className="text-xl font-semibold text-foreground">Data Preview</h3>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="border border-border shadow-sm rounded-lg">
            <div className="bg-muted border-b border-border py-3 px-4">
              <h4 className="text-base font-semibold text-foreground">Basic Information</h4>
            </div>
            <div className="space-y-2 p-4 text-sm">
              <p className="flex justify-between"><span className="text-muted-foreground">Title:</span> <span className="font-medium">{formData.title || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Subtitle:</span> <span className="font-medium">{formData.subtitle || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Description:</span> <span className="font-medium line-clamp-2">{formData.description || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">ISBN-13:</span> <span className="font-medium">{formData.isbn13 || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">ISBN-10:</span> <span className="font-medium">{formData.isbn10 || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Publication Date:</span> <span className="font-medium">{formData.publicationDate ? format(formData.publicationDate, "PPP") : "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Published Year:</span> <span className="font-medium">{formData.publishedYear || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Page Count:</span> <span className="font-medium">{formData.pageCount || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Language:</span> <span className="font-medium">{formData.language || "Not set"}</span></p>
            </div>
          </div>

          <div className="border border-border shadow-sm rounded-lg">
            <div className="bg-muted border-b border-border py-3 px-4">
              <h4 className="text-base font-semibold text-foreground">Pricing & Availability</h4>
            </div>
            <div className="space-y-2 p-4 text-sm">
              <p className="flex justify-between"><span className="text-muted-foreground">For Sale:</span> <span className="font-medium">{formData.forSale ? "Yes" : "No"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">For Rent:</span> <span className="font-medium">{formData.forRent ? "Yes" : "No"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Sale Price:</span> <span className="font-medium">{formData.priceSale || "Not set"}</span></p>
              {formData.forRent && (
                <>
                  <p className="flex justify-between"><span className="text-muted-foreground">Daily Rent Price:</span> <span className="font-medium">{formData.priceRentDaily || "Not set"}</span></p>
                  <p className="flex justify-between"><span className="text-muted-foreground">Weekly Rent Price:</span> <span className="font-medium">{formData.priceRentWeekly || "Not set"}</span></p>
                  <p className="flex justify-between"><span className="text-muted-foreground">Monthly Rent Price:</span> <span className="font-medium">{formData.priceRentMonthly || "Not set"}</span></p>
                </>
              )}
              <p className="flex justify-between"><span className="text-muted-foreground">Stock Quantity:</span> <span className="font-medium">{formData.stockQuantity || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Reserved Quantity:</span> <span className="font-medium">{formData.reservedQuantity || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Is Active:</span> <span className="font-medium">{formData.isActive ? "Yes" : "No"}</span></p>
            </div>
          </div>

          <div className="border border-border shadow-sm rounded-lg">
            <div className="bg-muted border-b border-border py-3 px-4">
              <h4 className="text-base font-semibold text-foreground">Categories & Genres</h4>
            </div>
            <div className="space-y-2 p-4 text-sm">
              <p className="flex justify-between"><span className="text-muted-foreground">Primary Category:</span> <span className="font-medium">{
                formData.primaryCategoryId
                  ? categories.find(c => c.id === formData.primaryCategoryId)?.name || "Unknown"
                  : "Not set"
              }</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Other Categories:</span> <span className="font-medium">{
                selectedCategories.length > 0
                  ? selectedCategories.map(id => categories.find(c => c.id === id)?.name).filter(Boolean).join(", ") || "None"
                  : "None"
              }</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Genres:</span> <span className="font-medium">{
                selectedGenres.length > 0
                  ? selectedGenres.map(id => genres.find(g => g.id === id)?.name).filter(Boolean).join(", ") || "None"
                  : "None"
              }</span></p>
            </div>
          </div>

          <div className="border border-border shadow-sm rounded-lg">
            <div className="bg-muted border-b border-border py-3 px-4">
              <h4 className="text-base font-semibold text-foreground">Additional Information</h4>
            </div>
            <div className="space-y-2 p-4 text-sm">
              <p className="flex justify-between"><span className="text-muted-foreground">Book Format:</span> <span className="font-medium">{formData.bookFormat || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Book Condition:</span> <span className="font-medium">{formData.bookCondition || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Edition:</span> <span className="font-medium">{formData.edition || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Dimensions:</span> <span className="font-medium">{formData.dimensions || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Weight (grams):</span> <span className="font-medium">{formData.weightGrams || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Average Rating:</span> <span className="font-medium">{formData.averageRating || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Total Ratings:</span> <span className="font-medium">{formData.totalRatings || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Total Reviews:</span> <span className="font-medium">{formData.totalReviews || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Publisher ID:</span> <span className="font-medium">{formData.publisherId || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Owner ID:</span> <span className="font-medium">{formData.ownerId || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Slug:</span> <span className="font-medium">{formData.slug || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Search Keywords:</span> <span className="font-medium">{formData.searchKeywords || "Not set"}</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Created By:</span> <span className="font-medium">{
                formData.createdBy
                  ? admins.find(a => a.id === formData.createdBy)?.name || "Unknown"
                  : "Not set"
              }</span></p>
              <p className="flex justify-between"><span className="text-muted-foreground">Last Modified By:</span> <span className="font-medium">{
                formData.lastModifiedBy
                  ? admins.find(a => a.id === formData.lastModifiedBy)?.name || "Unknown"
                  : "Not set"
              }</span></p>
            </div>
          </div>
        </div>
      </div>
    </form>
  );
}