import bcrypt from "bcrypt";

const salteRounds = 10;

/**
 * Hashes a password using bcrypt.
 * @param {string} password - The password to hash.
 * @returns {string} - The hashed password.
 * @throws {Error} - If hashing fails.
 *
 */
export const hashPassword = (password: string) => {
  const salt = bcrypt.genSaltSync(salteRounds);
  return bcrypt.hashSync(password, salt);
};

/**
 * Compares a password with a hashed password.
 * @param {string} password - The plain text password to compare.
 * @param {string} hash - The hashed password to compare against.
 * @returns {boolean} - True if the passwords match, false otherwise.
 */

export const comparerPassword = (password: string, hash: string) => {
  return bcrypt.compareSync(password, hash);
};
