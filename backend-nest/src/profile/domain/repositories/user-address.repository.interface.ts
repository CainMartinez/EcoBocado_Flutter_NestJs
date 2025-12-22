import { UserAddress } from '../../domain/entities/user-address.entity';

export const USER_ADDRESS_REPOSITORY_TOKEN = Symbol('IUserAddressRepository');

export interface IUserAddressRepository {
  /**
   * Crear una nueva dirección para un usuario
   */
  create(
    userId: number,
    data: {
      label: string;
      addressLine1: string;
      addressLine2?: string;
      city: string;
      stateProvince?: string;
      postalCode: string;
      country?: string;
      phone?: string;
      isDefault?: boolean;
    },
  ): Promise<UserAddress>;

  /**
   * Obtener todas las direcciones activas de un usuario
   */
  findByUserId(userId: number): Promise<UserAddress[]>;

  /**
   * Obtener una dirección específica por ID
   */
  findById(id: number): Promise<UserAddress | null>;

  /**
   * Actualizar una dirección existente
   */
  update(
    id: number,
    data: {
      label?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      stateProvince?: string;
      postalCode?: string;
      country?: string;
      phone?: string;
    },
  ): Promise<UserAddress>;

  /**
   * Marcar una dirección como predeterminada (y desmarcar las demás)
   */
  setAsDefault(userId: number, addressId: number): Promise<void>;

  /**
   * Eliminar (desactivar) una dirección
   */
  delete(id: number): Promise<void>;

  /**
   * Obtener la dirección predeterminada de un usuario
   */
  findDefaultByUserId(userId: number): Promise<UserAddress | null>;
}
