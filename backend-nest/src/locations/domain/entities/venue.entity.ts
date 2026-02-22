export class Venue {
  readonly id: number;
  readonly uuid: string | null;

  readonly code: string | null;
  readonly name: string | null;
  readonly email: string | null;
  readonly passwordHash: string | null;
  readonly avatarUrl: string | null;
  readonly phone: string | null;

  readonly timezone: string;
  readonly isActive: boolean;

  readonly createdAt: Date;
  readonly updatedAt: Date;

  constructor(props: {
    id: number;
    uuid: string | null;
    code: string | null;
    name: string | null;
    email: string | null;
    passwordHash: string | null;
    avatarUrl: string | null;
    phone: string | null;
    timezone: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }) {
    this.id = props.id;
    this.uuid = props.uuid ?? null;
    this.code = props.code ?? null;
    this.name = props.name ?? null;
    this.email = props.email ?? null;
    this.passwordHash = props.passwordHash ?? null;
    this.avatarUrl = props.avatarUrl ?? null;
    this.phone = props.phone ?? null;
    this.timezone = props.timezone;
    this.isActive = props.isActive;
    this.createdAt = props.createdAt;
    this.updatedAt = props.updatedAt;
  }

  static fromPrimitives(p: {
    id: number;
    uuid: string | null;
    code: string | null;
    name: string | null;
    email: string | null;
    passwordHash: string | null;
    avatarUrl: string | null;
    phone: string | null;
    timezone: string;
    isActive: boolean;
    createdAt: Date;
    updatedAt: Date;
  }): Venue {
    return new Venue({
      id: p.id,
      uuid: p.uuid ?? null,
      code: p.code ?? null,
      name: p.name ?? null,
      email: p.email ?? null,
      passwordHash: p.passwordHash ?? null,
      avatarUrl: p.avatarUrl ?? null,
      phone: p.phone ?? null,
      timezone: p.timezone,
      isActive: p.isActive,
      createdAt: p.createdAt,
      updatedAt: p.updatedAt,
    });
  }

  toPrimitives() {
    return {
      id: this.id,
      uuid: this.uuid,
      code: this.code,
      name: this.name,
      email: this.email,
      passwordHash: this.passwordHash,
      avatarUrl: this.avatarUrl,
      phone: this.phone,
      timezone: this.timezone,
      isActive: this.isActive,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
    };
  }
}