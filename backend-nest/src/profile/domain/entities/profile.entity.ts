export class Profile {
  readonly id: number;
  readonly ownerType: 'user' | 'admin';
  readonly ownerId: number;

  readonly phone: string | null;
  readonly addressLine1: string | null;
  readonly addressLine2: string | null;
  readonly city: string | null;
  readonly postalCode: string | null;
  readonly countryCode: string; // 'ES' por defecto en BD
  readonly avatarUrl: string | null;

  readonly isActive: boolean;

  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    ownerType: 'user' | 'admin';
    ownerId: number;
    phone: string | null;
    addressLine1: string | null;
    addressLine2: string | null;
    city: string | null;
    postalCode: string | null;
    countryCode: string;
    avatarUrl: string | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.ownerType = props.ownerType;
    this.ownerId = props.ownerId;

    this.phone = props.phone ?? null;
    this.addressLine1 = props.addressLine1 ?? null;
    this.addressLine2 = props.addressLine2 ?? null;
    this.city = props.city ?? null;
    this.postalCode = props.postalCode ?? null;
    this.countryCode = props.countryCode;
    this.avatarUrl = props.avatarUrl ?? null;

    this.isActive = props.isActive;
    
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    ownerType: 'user' | 'admin';
    ownerId: number;
    phone: string | null;
    addressLine1: string | null;
    addressLine2: string | null;
    city: string | null;
    postalCode: string | null;
    countryCode: string;
    avatarUrl: string | null;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): Profile {
    return new Profile({ ...p });
  }
}