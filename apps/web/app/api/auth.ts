"use server";

const login = async (previousState: unknown, formData: FormData) => {
  const email = formData.get("email") as string;
  const password = formData.get("password") as string;
  console.log("Login attempt with email:", email);
  if (!email || !password) {
    return { message: "Please provide email and password" };
  }
  await wait(3000);
  return {
    message: `Welcome back, ${email}! You have successfully logged in.`,
  };
};

const wait = (duration: number) => {
  return new Promise((res) => {
    setTimeout(res, duration);
  });
};

export default login;
