import bcrypt from "bcrypt";

const salteRounds = 10;

export const hashPassword = (password: string) => {
  const salt = bcrypt.genSaltSync(salteRounds);
  return bcrypt.hashSync(password, salt);
};

export const comparerPassword = (password: string, hash: string) => {
  return bcrypt.compareSync(password, hash);
};
