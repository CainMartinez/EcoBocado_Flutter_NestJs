export class UserAddress {
  readonly id: number;
  readonly userId: number;
  readonly label: string;
  readonly addressLine1: string;
  readonly addressLine2: string | null;
  readonly city: string;
  readonly stateProvince: string | null;
  readonly postalCode: string;
  readonly country: string;
  readonly phone: string | null;
  readonly isDefault: boolean;
  readonly isActive: boolean;
  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    userId: number;
    label: string;
    addressLine1: string;
    addressLine2: string | null;
    city: string;
    stateProvince: string | null;
    postalCode: string;
    country: string;
    phone: string | null;
    isDefault: boolean;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.userId = props.userId;
    this.label = props.label;
    this.addressLine1 = props.addressLine1;
    this.addressLine2 = props.addressLine2;
    this.city = props.city;
    this.stateProvince = props.stateProvince;
    this.postalCode = props.postalCode;
    this.country = props.country;
    this.phone = props.phone;
    this.isDefault = props.isDefault;
    this.isActive = props.isActive;
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    userId: number;
    label: string;
    addressLine1: string;
    addressLine2: string | null;
    city: string;
    stateProvince: string | null;
    postalCode: string;
    country: string;
    phone: string | null;
    isDefault: boolean;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): UserAddress {
    return new UserAddress({
      id: p.id,
      userId: p.userId,
      label: p.label,
      addressLine1: p.addressLine1,
      addressLine2: p.addressLine2,
      city: p.city,
      stateProvince: p.stateProvince,
      postalCode: p.postalCode,
      country: p.country,
      phone: p.phone,
      isDefault: p.isDefault,
      isActive: p.isActive,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    });
  }
}
