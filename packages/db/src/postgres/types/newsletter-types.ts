export type NewsletterSubscriber = {
  subscriber_id: string;
  email: string;
  is_subscribed: boolean;
  subscribed_at: Date;
  unsubscribed_at: Date | null;
  created_at: Date;
  updated_at: Date;
};

export type CreateNewsletterSubscriberData = {
  email: string;
};

export type UpdateNewsletterSubscriberData = {
  is_subscribed?: boolean;
  unsubscribed_at?: Date | null;
};