import {
  Controller,
  Post,
  Get,
  Param,
  Body,
  UseGuards,
  Req,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../../../auth/presentation/guards/jwt-auth.guard';
import { CreatePaymentIntentRequestDto } from '../../application/dto/request/create-payment-intent.request.dto';
import { PaymentIntentResponseDto, PaymentResponseDto } from '../../application/dto/response/payment.response.dto';
import { CreatePaymentIntentUseCase } from '../../application/use_cases/create-payment-intent.use-case';
import { GetPaymentStatusUseCase } from '../../application/use_cases/get-payment-status.use-case';

@ApiTags('Payments')
@ApiBearerAuth()
@Controller('payments')
@UseGuards(JwtAuthGuard)
export class PaymentController {
  constructor(
    private readonly createPaymentIntentUseCase: CreatePaymentIntentUseCase,
    private readonly getPaymentStatusUseCase: GetPaymentStatusUseCase,
  ) {}

  @Post('create-intent')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Crear un Payment Intent de Stripe',
    description: 'Crea un Payment Intent para procesar un pago. Devuelve el client secret necesario para completar el pago en el cliente.',
  })
  @ApiResponse({
    status: 201,
    description: 'Payment Intent creado exitosamente',
    type: PaymentIntentResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Datos de entrada inválidos' })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  async createPaymentIntent(
    @Req() req: any,
    @Body() dto: CreatePaymentIntentRequestDto,
  ): Promise<PaymentIntentResponseDto> {
    const userId = Number(req.user.sub);
    return await this.createPaymentIntentUseCase.execute(userId, dto);
  }

  @Get('status/:paymentIntentId')
  @ApiOperation({
    summary: 'Obtener estado de un pago',
    description: 'Consulta el estado actual de un pago mediante su Payment Intent ID',
  })
  @ApiParam({
    name: 'paymentIntentId',
    description: 'ID del Payment Intent de Stripe',
    example: 'pi_3ABC123DEF456',
  })
  @ApiResponse({
    status: 200,
    description: 'Estado del pago recuperado exitosamente',
    type: PaymentResponseDto,
  })
  @ApiResponse({ status: 401, description: 'No autorizado' })
  @ApiResponse({ status: 404, description: 'Pago no encontrado' })
  async getPaymentStatus(
    @Param('paymentIntentId') paymentIntentId: string,
  ): Promise<PaymentResponseDto> {
    return await this.getPaymentStatusUseCase.execute(paymentIntentId);
  }
}
