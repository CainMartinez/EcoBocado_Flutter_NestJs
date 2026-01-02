import { ApiProperty } from '@nestjs/swagger';

export class ProfileResponseDto {
  @ApiProperty({ example: 'user', enum: ['user', 'admin'] })
  ownerType: 'user' | 'admin';

  @ApiProperty({ example: 12 })
  ownerId: number;

  @ApiProperty({ example: 'usuario@example.com' })
  email: string;

  @ApiProperty({ example: 'Cain' })
  name: string;

  @ApiProperty({ example: 'https://i.pravatar.cc/200?u=usuario@example.com', nullable: true })
  avatarUrl: string | null;

  @ApiProperty({ example: '+34 600 111 222', nullable: true })
  phone: string | null;

  @ApiProperty({ example: 'C/ Principal 123', nullable: true })
  addressLine1: string | null;

  @ApiProperty({ example: 'Piso 2, puerta B', nullable: true })
  addressLine2: string | null;

  @ApiProperty({ example: 'Valencia', nullable: true })
  city: string | null;

  @ApiProperty({ example: '46870', nullable: true })
  postalCode: string | null;

  @ApiProperty({ example: 'ES', nullable: true })
  countryCode: string | null;

  @ApiProperty({ example: true })
  isActive: boolean;

  @ApiProperty({ example: '2025-10-25T18:05:00.000Z' })
  createdAt: Date;

  @ApiProperty({ example: '2025-10-25T18:15:00.000Z' })
  updatedAt: Date;
}