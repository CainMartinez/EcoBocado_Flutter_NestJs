import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiQuery, ApiResponse } from '@nestjs/swagger';
import { GetAvailablePickupSlotsUseCase } from '../../application/use_cases/get-available-pickup-slots.use-case';
import { PickupSlotResponseDto } from '../../application/dto/response/pickup-slot.response.dto';

@ApiTags('Pickup Slots')
@Controller('pickup-slots')
export class PickupSlotsController {
  constructor(
    private readonly getAvailablePickupSlotsUseCase: GetAvailablePickupSlotsUseCase,
  ) {}

  @Get('available')
  @ApiOperation({ summary: 'Obtener slots de recogida disponibles' })
  @ApiQuery({ name: 'startDate', required: false, description: 'Fecha de inicio (YYYY-MM-DD)' })
  @ApiQuery({ name: 'endDate', required: false, description: 'Fecha de fin (YYYY-MM-DD)' })
  @ApiResponse({ status: 200, description: 'Lista de slots disponibles', type: [PickupSlotResponseDto] })
  async getAvailableSlots(
    @Query('startDate') startDate?: string,
    @Query('endDate') endDate?: string,
  ): Promise<PickupSlotResponseDto[]> {
    return this.getAvailablePickupSlotsUseCase.execute(startDate, endDate);
  }
}
