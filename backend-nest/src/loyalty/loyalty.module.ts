import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { LoyaltyAccountOrmEntity } from './infrastructure/typeorm/entities-orm/loyalty-account.orm-entity';
import { LoyaltyRedemptionOrmEntity } from './infrastructure/typeorm/entities-orm/loyalty-redemption.orm-entity';
import { LoyaltyRuleOrmEntity } from './infrastructure/typeorm/entities-orm/loyalty-rule.orm-entity';
import { RescueMenuOrmEntity } from '../shop/infrastructure/typeorm/entities-orm/rescue-menu.orm-entity';
import { LoyaltyController } from './presentation/controllers/loyalty.controller';
import { GetLoyaltyAccountUseCase } from './application/use_cases/get-loyalty-account.use-case';
import { RedeemRewardUseCase } from './application/use_cases/redeem-reward.use-case';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      LoyaltyAccountOrmEntity,
      LoyaltyRedemptionOrmEntity,
      LoyaltyRuleOrmEntity,
      RescueMenuOrmEntity,
    ])
  ],
  controllers: [LoyaltyController],
  providers: [
    GetLoyaltyAccountUseCase,
    RedeemRewardUseCase,
  ],
  exports: [],
})
export class LoyaltyModule {}