"use client"

import { SignUpForm } from "@/components/auth/SignUpForm"
import { useNavbarStore } from "@/components/navbar/navbarStore"
import { useRouter } from "next/navigation"
import { useEffect } from "react"

export default function SignUpPage() {
  const { user } = useNavbarStore()
  const router = useRouter()
  
  // If user is already authenticated, redirect to home page
  useEffect(() => {
    if (user) {
      router.push("/")
    }
  }, [user, router])
  
  // Show nothing while checking authentication status
  if (user) {
    return null
  }
  
  return <SignUpForm />
}