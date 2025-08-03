export type User = {
  user_id: string;
  username: string;
  email: string;
  hashed_password: string;
  profile_image_url?: string;
  credits: number;
  loyalty_points: number;
  is_verified: boolean;
  role: string;
  last_login?: Date;
  created_at: Date;
  updated_at: Date;
};

export type CreateUserData = {
  username?: string;
  email: string;
  hashedPassword: string;
  profileImageUrl?: string;
  credits?: number;
  loyaltyPoints?: number;
  role?: string;
};

export type UpdateUserData = {
  username?: string;
  email?: string;
  hashedPassword?: string;
  profileImageUrl?: string;
  credits?: number;
  loyaltyPoints?: number;
  isVerified?: boolean;
  role?: string;
  lastLogin?: Date;
};
