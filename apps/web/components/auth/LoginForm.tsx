"use client"
import login from "@/app/api/auth/login"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { loginSchema } from "@/lib/schemas/authSchema"
import { BookOpenText, Library, Lock, Mail, Github, Eye, EyeOff } from "lucide-react"
import { useActionState, useState, useEffect } from "react"
import { toast } from "sonner"

export function LoginForm() {
        const [data, action, isPending] = useActionState(login, undefined)
        const [errors, setErrors] = useState<{ username?: string; password?: string }>({});
        const [showPassword, setShowPassword] = useState(false);

        useEffect(() => {
                if (data?.message && data?.user) {
                        toast.success("Login successful")
                        window.history.back()
                        setTimeout(() => {
                                window.location.reload()
                        }, 100)
                }
                if (data?.error) {
                        toast.error(data.error)
                }
        }, [data])

        const handleSubmit = async (formData: FormData) => {
                const values = {
                        username: formData.get("username") as string,
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
                                username: fieldErrors.username,
                                password: fieldErrors.password,
                        })
                        return
                }

                setErrors({})
                return action(formData)
        }

        const togglePasswordVisibility = () => {
                setShowPassword(!showPassword)
        }

        return (
                <div className="min-h-screen flex items-center justify-center bg-background p-4 relative overflow-hidden">
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
                                                Login to continue your literary journey
                                        </CardDescription>
                                </CardHeader>

                                <CardContent className="px-6 pb-4">
                                        <form action={handleSubmit} className="space-y-5">
                                                <div className="space-y-2">
                                                        <Label htmlFor="username" className="text-primary font-medium">
                                                                Username
                                                        </Label>
                                                        <div className="relative">
                                                                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
                                                                <Input
                                                                        id="username"
                                                                        name="username"
                                                                        placeholder="Enter your username"
                                                                        className={`placeholder:text-gray-400 pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary ${errors.username ? 'border-red-400 focus:border-red-400 focus:ring-red-400' : ''
                                                                                }`}
                                                                        aria-describedby={errors.username ? "username-error" : undefined}
                                                                        aria-invalid={!!errors.username}
                                                                />
                                                        </div>
                                                        {errors.username && (
                                                                <p id="username-error" className="text-red-400 text-sm" role="alert">
                                                                        {errors.username}
                                                                </p>
                                                        )}
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
                                                                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-muted-foreground pointer-events-none" />
                                                                <Input
                                                                        id="password"
                                                                        name="password"
                                                                        type={showPassword ? "text" : "password"}
                                                                        placeholder="Enter your password"
                                                                        className={`placeholder:text-gray-400 pl-10 py-5 bg-background border-border focus:border-secondary focus:ring-1 focus:ring-secondary pr-10 ${errors.password ? 'border-red-400 focus:border-red-400 focus:ring-red-400' : ''
                                                                                }`}
                                                                        aria-describedby={errors.password ? "password-error" : undefined}
                                                                        aria-invalid={!!errors.password}
                                                                />
                                                                <Button
                                                                        type="button"
                                                                        variant="ghost"
                                                                        size="icon"
                                                                        className="absolute right-0 top-0 h-full px-3 py-2 hover:bg-transparent"
                                                                        onClick={togglePasswordVisibility}
                                                                >
                                                                        {showPassword ? (
                                                                                <EyeOff className="h-4 w-4 text-muted-foreground" />
                                                                        ) : (
                                                                                <Eye className="h-4 w-4 text-muted-foreground" />
                                                                        )}
                                                                </Button>
                                                        </div>
                                                        {errors.password && (
                                                                <p id="password-error" className="text-red-400 text-sm" role="alert">
                                                                        {errors.password}
                                                                </p>
                                                        )}
                                                </div>

                                                <div className="flex items-center space-x-2">
                                                        <input
                                                                type="checkbox"
                                                                id="remember"
                                                                name="remember"
                                                                className="rounded border-border text-secondary focus:ring-secondary"
                                                        />
                                                        <Label htmlFor="remember" className="text-sm text-muted-foreground">
                                                                Remember this device
                                                        </Label>
                                                </div>

                                                <Button
                                                        disabled={isPending}
                                                        className="w-full py-5 bg-secondary hover:bg-secondary/90 text-accent font-medium rounded-lg transition-all duration-300 transform hover:scale-[1.02] disabled:opacity-50 disabled:transform-none"
                                                >
                                                        {isPending ? "Signing in..." : "Login to Library"}
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
                                        <Button variant="outline" className="w-full py-5 border-border hover:bg-muted/50 rounded-lg" disabled={isPending}>
                                                <Github className="mr-2 h-5 w-5" />
                                                Login with GitHub
                                        </Button>
                                </CardFooter>

                                <div className="text-center pb-8 px-6">
                                        <p className="text-sm text-muted-foreground">
                                                New to BookLab?{" "}
                                                <a href="/signup" className="text-secondary font-medium hover:underline">
                                                        Create your Account
                                                </a>
                                        </p>
                                </div>
                        </Card>
                </div>
        )
}
