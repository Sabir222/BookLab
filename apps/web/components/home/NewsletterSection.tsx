"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function NewsletterSection() {
  const [email, setEmail] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSubscribed, setIsSubscribed] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    
    // Simulate API call
    setTimeout(() => {
      setIsSubmitting(false);
      setIsSubscribed(true);
      setEmail("");
      
      // Reset success message after 3 seconds
      setTimeout(() => {
        setIsSubscribed(false);
      }, 3000);
    }, 1000);
  };

  return (
    <section className="w-full py-12 md:py-16">
      <div className="container mx-auto px-4">
        <div 
          className="rounded-2xl p-8 md:p-12 text-center"
          style={{ backgroundColor: "#11243E" }}
        >
          <div className="max-w-3xl mx-auto">
            <h2 className="text-2xl md:text-3xl font-bold text-white mb-4">
              Join Our Newsletter
            </h2>
            <p className="text-blue-100 text-lg mb-8 max-w-2xl mx-auto">
              Subscribe to get exclusive offers, new book recommendations, and reading tips delivered straight to your inbox.
            </p>
            
            {isSubscribed ? (
              <div className="bg-blue-500/20 border border-blue-400 rounded-lg py-3 px-4 text-blue-100 max-w-md mx-auto">
                <p>Thank you for subscribing! Check your email for confirmation.</p>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="flex flex-col sm:flex-row gap-4 max-w-md mx-auto">
                <Input
                  type="email"
                  placeholder="Enter your email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="flex-grow bg-white/10 border-white/20 text-white placeholder:text-blue-200 focus-visible:ring-white"
                />
                <Button 
                  type="submit" 
                  disabled={isSubmitting}
                  className="bg-white text-blue-900 hover:bg-blue-100 font-medium"
                >
                  {isSubmitting ? "Subscribing..." : "Subscribe"}
                </Button>
              </form>
            )}
            
            <p className="text-blue-200 text-sm mt-4">
              We respect your privacy. Unsubscribe at any time.
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}