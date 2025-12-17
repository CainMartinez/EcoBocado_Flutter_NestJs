export class DeliveryDriver {
  readonly id: number;
  readonly uuid: string | null;

  readonly email: string;
  readonly name: string;
  readonly phone: string;

  readonly passwordHash: string;
  readonly avatarUrl: string | null;

  readonly isActive: boolean;
  readonly isAvailable: boolean;

  readonly vehicleType: string | null; // 'bike', 'motorcycle', 'car'
  readonly vehiclePlate: string | null;

  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    uuid: string | null;
    email: string;
    name: string;
    phone: string;
    passwordHash: string;
    avatarUrl: string | null;
    isActive: boolean;
    isAvailable: boolean;
    vehicleType: string | null;
    vehiclePlate: string | null;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.uuid = props.uuid ?? null;
    this.email = props.email;
    this.name = props.name;
    this.phone = props.phone;
    this.passwordHash = props.passwordHash;
    this.avatarUrl = props.avatarUrl ?? null;
    this.isActive = props.isActive;
    this.isAvailable = props.isAvailable;
    this.vehicleType = props.vehicleType ?? null;
    this.vehiclePlate = props.vehiclePlate ?? null;
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    uuid: string | null;
    email: string;
    name: string;
    phone: string;
    passwordHash: string;
    avatarUrl: string | null;
    isActive: boolean;
    isAvailable: boolean;
    vehicleType: string | null;
    vehiclePlate: string | null;
    createdAt: Date;
    updatedAt: Date;
  }): DeliveryDriver {
    return new DeliveryDriver(p);
  }

  toPrimitives() {
    return {
      id: this.id,
      uuid: this.uuid,
      email: this.email,
      name: this.name,
      phone: this.phone,
      passwordHash: this.passwordHash,
      avatarUrl: this.avatarUrl,
      isActive: this.isActive,
      isAvailable: this.isAvailable,
      vehicleType: this.vehicleType,
      vehiclePlate: this.vehiclePlate,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}
