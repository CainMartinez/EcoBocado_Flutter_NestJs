import { Controller, Get, Post, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { GetLoyaltyAccountUseCase } from '../../application/use_cases/get-loyalty-account.use-case';
import { RedeemRewardUseCase } from '../../application/use_cases/redeem-reward.use-case';
import { RedeemRewardRequestDto } from '../../application/dto/request/redeem-reward.request.dto';
import { LoyaltyAccountResponseDto } from '../../application/dto/response/loyalty-account.response.dto';
import { LoyaltyRedemptionResponseDto } from '../../application/dto/response/loyalty-redemption.response.dto';

@ApiTags('loyalty')
@Controller('loyalty')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class LoyaltyController {
  constructor(
    private readonly getLoyaltyAccountUseCase: GetLoyaltyAccountUseCase,
    private readonly redeemRewardUseCase: RedeemRewardUseCase,
  ) {}

  @Get('account')
  @ApiOperation({ 
    summary: 'Obtener cuenta de fidelización del usuario',
    description: 'Retorna el estado de la cuenta de fidelización: puntos, compras y si tiene recompensa disponible'
  })
  @ApiResponse({ 
    status: 200, 
    description: 'Cuenta de fidelización obtenida exitosamente',
    type: LoyaltyAccountResponseDto
  })
  async getAccount(@Request() req: any): Promise<LoyaltyAccountResponseDto> {
    const userId = Number(req.user.sub);
    return this.getLoyaltyAccountUseCase.execute(userId);
  }

  @Post('redeem')
  @ApiOperation({ 
    summary: 'Canjear recompensa de fidelización',
    description: 'Canjea una recompensa por un menú gratuito. Requiere tener 10 compras acumuladas.'
  })
  @ApiResponse({ 
    status: 201, 
    description: 'Recompensa canjeada exitosamente',
    type: LoyaltyRedemptionResponseDto
  })
  @ApiResponse({ status: 400, description: 'No tiene suficientes compras para canjear' })
  @ApiResponse({ status: 404, description: 'Menú o cuenta no encontrada' })
  async redeemReward(
    @Request() req: any,
    @Body() dto: RedeemRewardRequestDto
  ): Promise<LoyaltyRedemptionResponseDto> {
    const userId = Number(req.user.sub);
    return this.redeemRewardUseCase.execute(userId, dto.rescueMenuId);
  }
}
