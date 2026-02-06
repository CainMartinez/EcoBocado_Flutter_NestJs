import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { LoyaltyAccountOrmEntity } from '../../infrastructure/typeorm/entities-orm/loyalty-account.orm-entity';
import { LoyaltyRuleOrmEntity } from '../../infrastructure/typeorm/entities-orm/loyalty-rule.orm-entity';
import { LoyaltyAccountResponseDto } from '../dto/response/loyalty-account.response.dto';

@Injectable()
export class GetLoyaltyAccountUseCase {
  constructor(
    @InjectRepository(LoyaltyAccountOrmEntity)
    private readonly loyaltyAccountRepo: Repository<LoyaltyAccountOrmEntity>,
    @InjectRepository(LoyaltyRuleOrmEntity)
    private readonly loyaltyRuleRepo: Repository<LoyaltyRuleOrmEntity>,
  ) {}

  async execute(userId: number): Promise<LoyaltyAccountResponseDto> {
    // Obtener o crear cuenta de fidelización
    let account = await this.loyaltyAccountRepo.findOne({
      where: { userId, isActive: true },
    });

    if (!account) {
      account = this.loyaltyAccountRepo.create({
        userId,
        points: 0,
        purchasesCount: 0,
        isActive: true,
      });
      account = await this.loyaltyAccountRepo.save(account);
    }

    // Obtener regla activa
    const rule = await this.loyaltyRuleRepo.findOne({
      where: { isActive: true },
      order: { id: 'DESC' },
    });

    const everyNPurchases = rule?.everyNPurchases || 10;
    const purchasesUntilReward = everyNPurchases - (account.purchasesCount % everyNPurchases);
    const hasAvailableReward = account.purchasesCount >= everyNPurchases && 
                                (account.purchasesCount % everyNPurchases) === 0;

    return {
      id: account.id,
      userId: account.userId,
      points: account.points,
      purchasesCount: account.purchasesCount,
      purchasesUntilReward: hasAvailableReward ? 0 : purchasesUntilReward,
      hasAvailableReward,
      isActive: account.isActive,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    };
  }
}
