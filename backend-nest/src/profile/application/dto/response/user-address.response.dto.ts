import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class UserAddressResponseDto {
  @ApiProperty({ description: 'ID de la dirección', example: 1 })
  id: number;

  @ApiProperty({ description: 'ID del usuario', example: 123 })
  userId: number;

  @ApiProperty({ description: 'Etiqueta de la dirección', example: 'Casa' })
  label: string;

  @ApiProperty({ description: 'Primera línea de dirección', example: 'Calle Principal 123' })
  addressLine1: string;

  @ApiPropertyOptional({ description: 'Segunda línea de dirección', example: 'Piso 2, Puerta B', nullable: true })
  addressLine2?: string | null;

  @ApiProperty({ description: 'Ciudad', example: 'Madrid' })
  city: string;

  @ApiPropertyOptional({ description: 'Estado/Provincia', example: 'Madrid', nullable: true })
  stateProvince?: string | null;

  @ApiProperty({ description: 'Código postal', example: '28001' })
  postalCode: string;

  @ApiProperty({ description: 'País', example: 'España' })
  country: string;

  @ApiPropertyOptional({ description: 'Teléfono de contacto', example: '+34612345678', nullable: true })
  phone?: string | null;

  @ApiProperty({ description: 'Es dirección predeterminada', example: true })
  isDefault: boolean;

  @ApiProperty({ description: 'Estado activo', example: true })
  isActive: boolean;

  @ApiProperty({ description: 'Fecha de creación', example: '2025-01-01T10:00:00.000Z' })
  createdAt: Date;

  @ApiProperty({ description: 'Fecha de última actualización', example: '2025-01-01T10:00:00.000Z' })
  updatedAt: Date;
}
