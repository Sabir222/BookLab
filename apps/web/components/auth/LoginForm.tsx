"use client"
import login from "@/app/api/auth"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { loginSchema } from "@/lib/schemas/auth"
import { BookOpenText, Library, Lock, Mail, Github } from "lucide-react"
import { useActionState, useState } from "react"


export function LoginForm() {
        const [data, action, isPending] = useActionState(login, undefined)
        const [errors, setErrors] = useState<{ email?: string; password?: string }>({});

        const handleSubmit = (formData: FormData) => {
                const values = {
                        email: formData.get("email") as string,
                        password: formData.get("password") as string,
                        remember: formData.get("remember") === "on",
                }

                const result = loginSchema.safeParse(values)
                if (!result.success) {
                        const fieldErrors: Record<string, string> = {}
                        for (const issue of result.error.issues) {
                                const fieldName = issue.path[0] as string
                                if (!fieldErrors[fieldName]) {
                                        fieldErrors[fieldName] = issue.message
                                }
                        }
                        setErrors({
                                email: fieldErrors.email,
                                password: fieldErrors.password,
                        })
                        return
                }

                setErrors({})
                return action(formData)
        }
        return (
                <div className="min-h-screen flex items-center justify-center bg-background p-4 relative overflow-hidden">
                        {data?.message}
                        <div className="absolute inset-0 overflow-hidden pointer-events-none">
                                <div className="absolute -top-20 -left-20 w-64 h-64 rounded-full bg-secondary/5 blur-3xl"></div>
                                <div className="absolute -bottom-20 -right-20 w-64 h-64 rounded-full bg-highlight/5 blur-3xl"></div>
                        </div>

                        <div className="absolute top-10 left-10 opacity-10">
                                <BookOpenText className="h-24 w-24 text-secondary" />
                        </div>

                        <div className="absolute bottom-10 right-10 opacity-10">
                                <Library className="h-24 w-24 text-secondary" />
                        </div>

                        <Card className="w-full max-w-md bg-card border-border shadow-xl rounded-2xl overflow-hidden backdrop-blur-sm bg-opacity-90 relative z-10">
                                <CardHeader className="text-center pb-4 pt-8">
                                        <div className="mx-auto bg-secondary/10 p-3 rounded-full w-16 h-16 flex items-center justify-center mb-4">
                                                <BookOpenText className="h-8 w-8 text-secondary" />
                                        </div>
                                        <CardTitle className="text-2xl font-serif font-bold text-primary">Welcome Back</CardTitle>
                                        <CardDescription className="text-muted-foreground">
                                                Sign in to continue your literary journey
                                        </CardDescription>
                                </CardHeader>

                                <CardContent className="px-6 pb-4">
                                        <form action={handleSubmit} className="space-y-5">
                                                <div className="space-y-2">
                                                        <Label htmlFor="email" className="text-primary font-medium">
                                                                Email Address
                                                        </Label>
                                                        <div className="relative">
                                                                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                                                                <Input
                                                                        id="email"
                                                                        type="email"
                                                                        name="email"
                                                                        placeholder="reader@booklab.com"
                                                                        className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                                                                />
                                                                <p className="text-red-800">{errors.email}</p>
                                                        </div>
                                                </div>

                                                <div className="space-y-2">
                                                        <div className="flex justify-between items-center">
                                                                <Label htmlFor="password" className="text-primary font-medium">
                                                                        Password
                                                                </Label>
                                                                <a href="#" className="text-sm text-secondary hover:underline">
                                                                        Forgot?
                                                                </a>
                                                        </div>
                                                        <div className="relative">
                                                                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                                                                <Input
                                                                        id="password"
                                                                        name="password"
                                                                        type="password"
                                                                        placeholder="••••••••"
                                                                        className="pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary"
                                                                />
                                                                <p className="text-red-800">{errors.password}</p>
                                                        </div>
                                                </div>

                                                <div className="flex items-center space-x-2">
                                                        <input
                                                                type="checkbox"
                                                                id="remember"
                                                                className="rounded border-border text-secondary focus:ring-secondary"
                                                        />
                                                        <Label htmlFor="remember" className="text-sm text-muted-foreground">
                                                                Remember this device
                                                        </Label>
                                                </div>

                                                <Button disabled={isPending} className="w-full py-5 bg-secondary hover:bg-secondary/90 text-accent font-medium rounded-lg transition-all duration-300 transform hover:scale-[1.02]">
                                                        Sign In to Library
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
                                                                Continue with
                                                        </span>
                                                </div>
                                        </div>
                                </div>

                                <CardFooter className="p-6 pt-4">
                                        <Button variant="outline" className="w-full py-5 border-border hover:bg-muted/50 rounded-lg">
                                                <Github className="mr-2 h-5 w-5" />
                                                Sign in with GitHub
                                        </Button>
                                </CardFooter>

                                <div className="text-center pb-8 px-6">
                                        <p className="text-sm text-muted-foreground">
                                                New to BookLab?{" "}
                                                <a href="/signup" className="text-secondary font-medium hover:underline">
                                                        Create your reading nook
                                                </a>
                                        </p>
                                </div>
                        </Card>
                </div>
        )
}
