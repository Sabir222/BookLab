export type User = {
  user_id: number;
  username: string;
  email: string;
  hashed_password: string;
  profile_image_url?: string | null;
  credits: number;
  loyalty_points: number;
  is_verified: boolean;
  role: "user" | "admin"; // remove `| string` for safety
  last_login: string | null; // or Date
  created_at: string; // or Date
  updated_at: string; // or Date
};
