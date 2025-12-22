import type { UserAllergen } from '../entities/user-allergen.entity';

export const USER_ALLERGEN_REPOSITORY_TOKEN = Symbol('USER_ALLERGEN_REPOSITORY_TOKEN');

export interface IUserAllergenRepository {
  /**
   * Agrega un alérgeno al perfil del usuario
   */
  add(userId: number, allergenCode: string): Promise<UserAllergen>;

  /**
   * Elimina un alérgeno del perfil del usuario
   */
  remove(userId: number, allergenCode: string): Promise<void>;

  /**
   * Obtiene todos los códigos de alérgenos del usuario
   */
  findAllergenCodesByUserId(userId: number): Promise<string[]>;

  /**
   * Verifica si el usuario tiene un alérgeno específico
   */
  hasAllergen(userId: number, allergenCode: string): Promise<boolean>;
}
