import { IsString, IsOptional, IsBoolean, MaxLength, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserAddressRequestDto {
  @ApiProperty({ description: 'Etiqueta de la dirección (ej. Casa, Oficina)', example: 'Casa' })
  @IsString()
  @MaxLength(100)
  label: string;

  @ApiProperty({ description: 'Primera línea de dirección', example: 'Calle Principal 123' })
  @IsString()
  @MaxLength(255)
  addressLine1: string;

  @ApiPropertyOptional({ description: 'Segunda línea de dirección (opcional)', example: 'Piso 2, Puerta B' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  addressLine2?: string;

  @ApiProperty({ description: 'Ciudad', example: 'Madrid' })
  @IsString()
  @MaxLength(100)
  city: string;

  @ApiPropertyOptional({ description: 'Estado/Provincia', example: 'Madrid' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  stateProvince?: string;

  @ApiProperty({ description: 'Código postal', example: '28001' })
  @IsString()
  @MinLength(4)
  @MaxLength(20)
  postalCode: string;

  @ApiPropertyOptional({ description: 'País', example: 'España' })
  @IsOptional()
  @IsString()
  @MaxLength(100)
  country?: string;

  @ApiPropertyOptional({ description: 'Teléfono de contacto', example: '+34612345678' })
  @IsOptional()
  @IsString()
  @MaxLength(20)
  phone?: string;

  @IsOptional()
  @IsBoolean()
  isDefault?: boolean;
}
