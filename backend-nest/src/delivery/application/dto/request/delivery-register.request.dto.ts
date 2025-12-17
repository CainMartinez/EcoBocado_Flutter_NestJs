import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MinLength, IsOptional, IsEnum } from 'class-validator';
import { Transform } from 'class-transformer';

/**
 * DTO para el registro de nuevos repartidores
 * Este endpoint debe estar protegido y solo accesible desde el panel de administración
 */
export class DeliveryRegisterRequestDto {
  @ApiProperty({
    example: 'driver@example.com',
    description: 'Email único del repartidor',
  })
  @IsEmail({}, { message: 'Email inválido' })
  @IsNotEmpty({ message: 'El email es requerido' })
  @Transform(({ value }) => (typeof value === 'string' ? value.trim().toLowerCase() : value))
  email: string;

  @ApiProperty({
    example: 'Juan Repartidor',
    description: 'Nombre completo del repartidor',
    minLength: 2,
  })
  @IsString({ message: 'El nombre debe ser texto' })
  @IsNotEmpty({ message: 'El nombre es requerido' })
  @MinLength(2, { message: 'El nombre debe tener al menos 2 caracteres' })
  name: string;

  @ApiProperty({
    example: '+34666777888',
    description: 'Número de teléfono del repartidor',
    minLength: 9,
  })
  @IsString({ message: 'El teléfono debe ser texto' })
  @IsNotEmpty({ message: 'El teléfono es requerido' })
  @MinLength(9, { message: 'El teléfono debe tener al menos 9 caracteres' })
  phone: string;

  @ApiProperty({
    example: 'delivery123',
    description: 'Contraseña del repartidor',
    minLength: 6,
  })
  @IsString({ message: 'La contraseña debe ser texto' })
  @IsNotEmpty({ message: 'La contraseña es requerida' })
  @MinLength(6, { message: 'La contraseña debe tener al menos 6 caracteres' })
  password: string;

  @ApiProperty({
    example: 'motorcycle',
    description: 'Tipo de vehículo del repartidor',
    enum: ['bike', 'motorcycle', 'car'],
    required: false,
  })
  @IsEnum(['bike', 'motorcycle', 'car'], { message: 'Tipo de vehículo inválido' })
  @IsOptional()
  vehicleType?: 'bike' | 'motorcycle' | 'car';

  @ApiProperty({
    example: 'ABC1234',
    description: 'Matrícula del vehículo',
    required: false,
  })
  @IsString({ message: 'La matrícula debe ser texto' })
  @IsOptional()
  vehiclePlate?: string;
}
