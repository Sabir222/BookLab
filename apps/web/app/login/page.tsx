"use client"

import { LoginForm } from "@/components/auth/LoginForm"
import { useNavbarStore } from "@/components/navbar/navbarStore"
import { useRouter } from "next/navigation"
import { useEffect, useState } from "react"

export default function LoginPage() {
  const { user } = useNavbarStore()
  const router = useRouter()
  const [isCheckingAuth, setIsCheckingAuth] = useState(true)
  
  // If user is already authenticated, redirect to home page
  useEffect(() => {
    if (user) {
      router.push("/")
    } else {
      setIsCheckingAuth(false)
    }
  }, [user, router])
  
  // Show nothing while checking authentication status
  if (isCheckingAuth) {
    return null
  }
  
  return <LoginForm />
}