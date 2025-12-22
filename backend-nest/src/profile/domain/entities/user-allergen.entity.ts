export class UserAllergen {
  readonly id: number;
  readonly userId: number;
  readonly allergenCode: string;
  readonly createdAt: Date;

  constructor(props: {
    id: number;
    userId: number;
    allergenCode: string;
    createdAt: Date;
  }) {
    this.id = props.id;
    this.userId = props.userId;
    this.allergenCode = props.allergenCode;
    this.createdAt = props.createdAt;
  }

  static fromPrimitives(data: {
    id: number;
    userId: number;
    allergenCode: string;
    createdAt: Date;
  }): UserAllergen {
    return new UserAllergen(data);
  }

  toPrimitives() {
    return {
      id: this.id,
      userId: this.userId,
      allergenCode: this.allergenCode,
      createdAt: this.createdAt,
    };
  }
}
