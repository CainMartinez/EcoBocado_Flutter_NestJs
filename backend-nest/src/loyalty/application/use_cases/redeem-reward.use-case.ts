import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LoyaltyAccountOrmEntity } from '../../infrastructure/typeorm/entities-orm/loyalty-account.orm-entity';
import { LoyaltyRuleOrmEntity } from '../../infrastructure/typeorm/entities-orm/loyalty-rule.orm-entity';
import { LoyaltyRedemptionOrmEntity } from '../../infrastructure/typeorm/entities-orm/loyalty-redemption.orm-entity';
import { RescueMenuOrmEntity } from '../../../shop/infrastructure/typeorm/entities-orm/rescue-menu.orm-entity';
import { LoyaltyRedemptionResponseDto } from '../dto/response/loyalty-redemption.response.dto';

@Injectable()
export class RedeemRewardUseCase {
  constructor(
    @InjectRepository(LoyaltyAccountOrmEntity)
    private readonly loyaltyAccountRepo: Repository<LoyaltyAccountOrmEntity>,
    @InjectRepository(LoyaltyRuleOrmEntity)
    private readonly loyaltyRuleRepo: Repository<LoyaltyRuleOrmEntity>,
    @InjectRepository(LoyaltyRedemptionOrmEntity)
    private readonly redemptionRepo: Repository<LoyaltyRedemptionOrmEntity>,
    @InjectRepository(RescueMenuOrmEntity)
    private readonly rescueMenuRepo: Repository<RescueMenuOrmEntity>,
  ) {}

  async execute(userId: number, rescueMenuId: number): Promise<LoyaltyRedemptionResponseDto> {
    // Verificar cuenta de fidelización
    const account = await this.loyaltyAccountRepo.findOne({
      where: { userId, isActive: true },
    });

    if (!account) {
      throw new NotFoundException('Cuenta de fidelización no encontrada');
    }

    // Obtener regla activa
    const rule = await this.loyaltyRuleRepo.findOne({
      where: { isActive: true },
      order: { id: 'DESC' },
    });

    if (!rule) {
      throw new NotFoundException('No hay reglas de fidelización activas');
    }

    // Verificar si el usuario tiene recompensa disponible
    const everyNPurchases = rule.everyNPurchases;
    const hasReward = account.purchasesCount >= everyNPurchases && 
                      (account.purchasesCount % everyNPurchases) === 0;

    if (!hasReward) {
      throw new BadRequestException(
        `Necesitas ${everyNPurchases - (account.purchasesCount % everyNPurchases)} compras más para obtener una recompensa`
      );
    }

    // Verificar que el menú existe
    const rescueMenu = await this.rescueMenuRepo.findOne({
      where: { id: rescueMenuId, isActive: true },
    });

    if (!rescueMenu) {
      throw new NotFoundException('Menú no encontrado');
    }

    // Crear redención
    const redemption = this.redemptionRepo.create({
      userId,
      ruleId: rule.id,
      rescueMenuId,
      orderId: null,
      redeemedAt: new Date(),
      isActive: true,
    });

    const savedRedemption = await this.redemptionRepo.save(redemption);

    // Vaciar el contador (poner a 0 para empezar de nuevo)
    account.purchasesCount = 0;
    await this.loyaltyAccountRepo.save(account);

    return {
      id: savedRedemption.id,
      userId: savedRedemption.userId,
      ruleId: savedRedemption.ruleId,
      rescueMenuId: savedRedemption.rescueMenuId,
      rescueMenuName: rescueMenu.nameEs || rescueMenu.nameEn || 'Menú',
      orderId: savedRedemption.orderId,
      redeemedAt: savedRedemption.redeemedAt,
      isActive: savedRedemption.isActive,
    };
  }
}
