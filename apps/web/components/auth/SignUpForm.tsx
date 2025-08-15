"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { Bookmark, Library, User, Lock, Mail, Github } from "lucide-react"

export function SignUpForm() {
  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4 relative overflow-hidden">
      {/* Decorative book elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-20 -right-20 w-64 h-64 rounded-full bg-secondary/5 blur-3xl"></div>
        <div className="absolute -bottom-20 -left-20 w-64 h-64 rounded-full bg-highlight/5 blur-3xl"></div>
      </div>
      
      <div className="absolute top-10 right-10 opacity-10">
        <Bookmark className="h-24 w-24 text-secondary" />
      </div>
      
      <div className="absolute bottom-10 left-10 opacity-10">
        <Library className="h-24 w-24 text-secondary" />
      </div>
      
      <Card className="w-full max-w-md bg-card border-border shadow-xl rounded-2xl overflow-hidden backdrop-blur-sm bg-opacity-90 relative z-10">
        <CardHeader className="text-center pb-4 pt-8">
          <div className="mx-auto bg-secondary/10 p-3 rounded-full w-16 h-16 flex items-center justify-center mb-4">
            <Bookmark className="h-8 w-8 text-secondary" />
          </div>
          <CardTitle className="text-2xl font-serif font-bold text-primary">Join Our Library</CardTitle>
          <CardDescription className="text-muted-foreground">
            Create your personal reading sanctuary
          </CardDescription>
        </CardHeader>
        
        <CardContent className="px-6 pb-4">
          <form className="space-y-5">
            <div className="space-y-2">
              <Label htmlFor="username" className="text-primary font-medium">
                Username
              </Label>
              <div className="relative">
                <User className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="username"
                  placeholder="booklover2023"
                  className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="email" className="text-primary font-medium">
                Email Address
              </Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="email"
                  type="email"
                  placeholder="reader@booklab.com"
                  className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="password" className="text-primary font-medium">
                Password
              </Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="password"
                  type="password"
                  placeholder="••••••••"
                  className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>
            
            <div className="space-y-2">
              <Label htmlFor="confirmPassword" className="text-primary font-medium">
                Confirm Password
              </Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="confirmPassword"
                  type="password"
                  placeholder="••••••••"
                  className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                />
              </div>
            </div>
            
            <div className="space-y-3">
              <div className="flex items-start">
                <div className="flex items-center h-5 mt-1">
                  <input
                    id="terms"
                    aria-describedby="terms-description"
                    name="terms"
                    type="checkbox"
                    className="h-4 w-4 rounded border-border text-secondary focus:ring-secondary"
                  />
                </div>
                <div className="ml-3 text-sm">
                  <Label htmlFor="terms" className="text-muted-foreground">
                    I agree to the{" "}
                    <a href="#" className="text-secondary font-medium hover:underline">
                      Terms of Service
                    </a>{" "}
                    and{" "}
                    <a href="#" className="text-secondary font-medium hover:underline">
                      Privacy Policy
                    </a>
                  </Label>
                  <p id="terms-description" className="text-muted-foreground/70 mt-1">
                    I confirm that I am at least 13 years old.
                  </p>
                </div>
              </div>
            </div>
            
            <Button className="w-full py-5 bg-secondary hover:bg-secondary/90 text-accent font-medium rounded-lg transition-all duration-300 transform hover:scale-[1.02]">
              Create Reading Nook
            </Button>
          </form>
        </CardContent>
        
        <div className="px-6">
          <div className="relative">
            <div className="absolute inset-0 flex items-center">
              <Separator className="w-full border-border" />
            </div>
            <div className="relative flex justify-center text-xs uppercase">
              <span className="bg-card px-2 text-muted-foreground">
                Or join with
              </span>
            </div>
          </div>
        </div>
        
        <CardFooter className="p-6 pt-4">
          <Button variant="outline" className="w-full py-5 border-border hover:bg-muted/50 rounded-lg">
            <Github className="mr-2 h-5 w-5" />
            Sign up with GitHub
          </Button>
        </CardFooter>
        
        <div className="text-center pb-8 px-6">
          <p className="text-sm text-muted-foreground">
            Already have a library card?{" "}
            <a href="/login" className="text-secondary font-medium hover:underline">
              Enter the stacks
            </a>
          </p>
        </div>
      </Card>
    </div>
  )
}