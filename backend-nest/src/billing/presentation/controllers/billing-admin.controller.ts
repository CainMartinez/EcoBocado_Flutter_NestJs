import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { AdminGuard } from '../../../auth/presentation/guards/admin.guard';
import { GetAllBillingRecordsUseCase } from '../../application/use_cases/get-all-billing-records.usecase';
import { BillingRecordResponseDto } from '../../application/dto/response/billing-record.response.dto';

@ApiTags('Admin - Billing')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, AdminGuard)
@Controller('admin/billing')
export class BillingAdminController {
  constructor(
    private readonly getAllBillingRecordsUseCase: GetAllBillingRecordsUseCase,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Get all billing records (admin only)' })
  @ApiResponse({
    status: 200,
    description: 'Billing records retrieved successfully',
    type: [BillingRecordResponseDto],
  })
  async getAllBillingRecords(): Promise<BillingRecordResponseDto[]> {
    return this.getAllBillingRecordsUseCase.execute();
  }
}
