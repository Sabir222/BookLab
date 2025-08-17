

"use client";

import { useState, useRef, useEffect } from "react";
import { useRouter } from "next/navigation";
import { useNavbarStore } from "@/components/navbar/navbarStore";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Separator } from "@/components/ui/separator";
import { Camera, User, Mail, CreditCard, Trophy, Calendar, Save, Upload, Shield, Bell, Trash2, Lock } from "lucide-react";
import { toast } from "sonner";

const ProfilePage = () => {
  const { user, setUser } = useNavbarStore();
  const router = useRouter();
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [previewImage, setPreviewImage] = useState<string | null>(null);
  const [isUploading, setIsUploading] = useState(false);
  const [formData, setFormData] = useState({
    username: "",
    email: "",
    profile_image_url: "",
  });

  // Initialize form data with user info
  useEffect(() => {
    if (user) {
      setFormData({
        username: user.username || "",
        email: user.email || "",
        profile_image_url: user.profile_image_url || "",
      });
      setPreviewImage(user.profile_image_url || null);
    }
  }, [user]);

  // Redirect to login if not authenticated
  useEffect(() => {
    if (!user) {
      router.push("/login");
    }
  }, [user, router]);

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith("image/")) {
      toast.error("Please select an image file");
      return;
    }

    // Validate file size (max 5MB)
    if (file.size > 5 * 1024 * 1024) {
      toast.error("File size should be less than 5MB");
      return;
    }

    // Create preview
    const reader = new FileReader();
    reader.onloadend = () => {
      setPreviewImage(reader.result as string);
    };
    reader.readAsDataURL(file);

    // In a real app, you would upload the file to your server here
    // For now, we'll just show the preview
    toast.info("In a real application, this image would be uploaded to the server");
  };

  const triggerFileInput = () => {
    fileInputRef.current?.click();
  };

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsUploading(true);

    try {
      // In a real application, you would send the form data to your API here
      // For demonstration, we'll just update the local state
      setUser({
        ...user!,
        username: formData.username,
        email: formData.email,
        profile_image_url: previewImage || user?.profile_image_url || ""
      });

      toast.success("Profile updated successfully!");
    } catch (error) {
      toast.error("Failed to update profile");
      console.error("Profile update error:", error);
    } finally {
      setIsUploading(false);
    }
  };

  const handleDeleteAccount = () => {
    toast("Account deletion", {
      description: "In a real application, this would delete your account",
      action: {
        label: "Confirm",
        onClick: () => {
          toast.success("Account deleted successfully");
          // In a real app, you would call your API to delete the account
        }
      }
    });
  };

  if (!user) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div>
          <p className="mt-4 text-muted-foreground">Loading profile...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="container max-w-4xl py-8 mx-auto">
      <div className="flex flex-col md:flex-row gap-8">
        {/* Profile Header */}
        <div className="md:w-1/3">
          <Card className="bg-accent/50 border-border/50">
            <CardHeader className="text-center">
              <div className="relative mx-auto">
                <Avatar className="w-32 h-32 mx-auto">
                  <AvatarImage src={previewImage || user.profile_image_url || ""} alt={user.username} />
                  <AvatarFallback className="text-2xl bg-secondary text-secondary-foreground">
                    {user.username?.charAt(0).toUpperCase() || "U"}
                  </AvatarFallback>
                </Avatar>
                <Button
                  variant="secondary"
                  size="icon"
                  className="absolute bottom-2 right-2 rounded-full shadow-md hover:shadow-lg transition-shadow"
                  onClick={triggerFileInput}
                >
                  <Camera className="h-4 w-4" />
                </Button>
                <input
                  type="file"
                  ref={fileInputRef}
                  className="hidden"
                  accept="image/*"
                  onChange={handleImageChange}
                />
              </div>
              <CardTitle className="mt-4 text-primary">{user.username}</CardTitle>
              <CardDescription>{user.email}</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="space-y-4">
                <div className="flex items-center justify-between p-3 bg-background rounded-lg">
                  <span className="text-sm text-muted-foreground flex items-center">
                    <CreditCard className="h-4 w-4 mr-2" />
                    Credits
                  </span>
                  <span className="font-medium">{user.credits || 0}</span>
                </div>
                <div className="flex items-center justify-between p-3 bg-background rounded-lg">
                  <span className="text-sm text-muted-foreground flex items-center">
                    <Trophy className="h-4 w-4 mr-2" />
                    Loyalty Points
                  </span>
                  <span className="font-medium">{user.loyalty_points || 0}</span>
                </div>
                <div className="flex items-center justify-between p-3 bg-background rounded-lg">
                  <span className="text-sm text-muted-foreground flex items-center">
                    <Calendar className="h-4 w-4 mr-2" />
                    Last Login
                  </span>
                  <span className="font-medium text-sm">
                    {user.last_login 
                      ? new Date(user.last_login).toLocaleDateString() 
                      : "Unknown"}
                  </span>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Profile Content */}
        <div className="md:w-2/3">
          <Tabs defaultValue="profile" className="w-full">
            <TabsList className="grid w-full grid-cols-2 mb-6">
              <TabsTrigger value="profile" className="data-[state=active]:bg-secondary data-[state=active]:text-secondary-foreground">
                Profile
              </TabsTrigger>
              <TabsTrigger value="settings" className="data-[state=active]:bg-secondary data-[state=active]:text-secondary-foreground">
                Settings
              </TabsTrigger>
            </TabsList>
            
            <TabsContent value="profile">
              <Card className="bg-accent/50 border-border/50">
                <CardHeader>
                  <CardTitle className="text-primary">Profile Information</CardTitle>
                  <CardDescription>
                    Update your personal information and profile picture
                  </CardDescription>
                </CardHeader>
                <form onSubmit={handleSubmit}>
                  <CardContent className="space-y-6">
                    <div className="space-y-2">
                      <Label htmlFor="username" className="text-secondary">Username</Label>
                      <div className="relative">
                        <User className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                        <Input
                          id="username"
                          name="username"
                          value={formData.username}
                          onChange={handleInputChange}
                          className="pl-10 bg-background border-border"
                          placeholder="Your username"
                        />
                      </div>
                    </div>
                    
                    <div className="space-y-2">
                      <Label htmlFor="email" className="text-secondary">Email</Label>
                      <div className="relative">
                        <Mail className="absolute left-3 top-3 h-4 w-4 text-muted-foreground" />
                        <Input
                          id="email"
                          name="email"
                          type="email"
                          value={formData.email}
                          onChange={handleInputChange}
                          className="pl-10 bg-background border-border"
                          placeholder="your.email@example.com"
                        />
                      </div>
                    </div>
                    
                    <div className="space-y-2">
                      <Label className="text-secondary">Profile Picture</Label>
                      <div className="flex items-center gap-4">
                        <Avatar className="w-16 h-16">
                          <AvatarImage src={previewImage || user.profile_image_url || ""} alt={user.username} />
                          <AvatarFallback className="bg-secondary text-secondary-foreground">
                            {user.username?.charAt(0).toUpperCase() || "U"}
                          </AvatarFallback>
                        </Avatar>
                        <Button
                          type="button"
                          variant="outline"
                          onClick={triggerFileInput}
                          disabled={isUploading}
                          className="border-border hover:bg-accent"
                        >
                          <Upload className="h-4 w-4 mr-2" />
                          Change Picture
                        </Button>
                      </div>
                    </div>
                  </CardContent>
                  <CardFooter className="border-t border-border/50 px-6 py-4">
                    <Button 
                      type="submit" 
                      disabled={isUploading} 
                      className="ml-auto bg-secondary text-secondary-foreground hover:bg-secondary/90"
                    >
                      {isUploading ? (
                        <>
                          <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-current border-t-transparent"></div>
                          Saving...
                        </>
                      ) : (
                        <>
                          <Save className="h-4 w-4 mr-2" />
                          Save Changes
                        </>
                      )}
                    </Button>
                  </CardFooter>
                </form>
              </Card>
            </TabsContent>
            
            <TabsContent value="settings">
              <Card className="bg-accent/50 border-border/50">
                <CardHeader>
                  <CardTitle className="text-primary">Account Settings</CardTitle>
                  <CardDescription>
                    Manage your account preferences and security settings
                  </CardDescription>
                </CardHeader>
                <CardContent className="space-y-6">
                  <div className="rounded-lg border border-border/50 p-4 bg-background">
                    <div className="flex items-center mb-3">
                      <Shield className="h-5 w-5 text-secondary mr-2" />
                      <h3 className="font-medium">Account Security</h3>
                    </div>
                    <p className="text-sm text-muted-foreground mb-4">
                      Manage your password and security preferences
                    </p>
                    <Button variant="outline" className="border-border hover:bg-accent">
                      <Lock className="h-4 w-4 mr-2" />
                      Change Password
                    </Button>
                  </div>
                  
                  <Separator className="bg-border/50" />
                  
                  <div className="rounded-lg border border-border/50 p-4 bg-background">
                    <div className="flex items-center mb-3">
                      <Bell className="h-5 w-5 text-secondary mr-2" />
                      <h3 className="font-medium">Notification Preferences</h3>
                    </div>
                    <p className="text-sm text-muted-foreground mb-4">
                      Choose what notifications you want to receive
                    </p>
                    <div className="space-y-3">
                      <div className="flex items-center justify-between">
                        <span className="text-sm">Email Notifications</span>
                        <Button 
                          variant="outline" 
                          size="sm" 
                          className="border-border hover:bg-accent"
                        >
                          Enabled
                        </Button>
                      </div>
                      <div className="flex items-center justify-between">
                        <span className="text-sm">SMS Notifications</span>
                        <Button 
                          variant="outline" 
                          size="sm" 
                          className="border-border hover:bg-accent"
                        >
                          Disabled
                        </Button>
                      </div>
                    </div>
                  </div>
                  
                  <Separator className="bg-border/50" />
                  
                  <div className="rounded-lg border border-destructive/50 p-4 bg-background">
                    <div className="flex items-center mb-3">
                      <Trash2 className="h-5 w-5 text-destructive mr-2" />
                      <h3 className="font-medium text-destructive">Danger Zone</h3>
                    </div>
                    <p className="text-sm text-muted-foreground mb-4">
                      Permanently delete your account and all associated data
                    </p>
                    <Button 
                      variant="destructive" 
                      onClick={handleDeleteAccount}
                    >
                      Delete Account
                    </Button>
                  </div>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </div>
    </div>
  );
};

export default ProfilePage;
