import { ApiProperty } from '@nestjs/swagger';

export class PickupSlotResponseDto {
  @ApiProperty({ description: 'ID del slot de recogida', example: 1 })
  id: number;

  @ApiProperty({ description: 'ID del venue', example: 1 })
  venueId: number;

  @ApiProperty({ description: 'Fecha del slot (YYYY-MM-DD)', example: '2025-12-20' })
  slotDate: string;

  @ApiProperty({ description: 'Hora de inicio (HH:MM:SS)', example: '12:00:00' })
  startTime: string;

  @ApiProperty({ description: 'Hora de fin (HH:MM:SS)', example: '12:30:00' })
  endTime: string;

  @ApiProperty({ description: 'Capacidad total', example: 10 })
  capacity: number;

  @ApiProperty({ description: 'Cantidad reservada', example: 3 })
  bookedCount: number;

  @ApiProperty({ description: 'Si está activo', example: true })
  isActive: boolean;

  @ApiProperty({ description: 'Fecha de creación' })
  createdAt: Date;

  @ApiProperty({ description: 'Fecha de última actualización' })
  updatedAt: Date;
}
