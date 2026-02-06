export class LoyaltyAccountResponseDto {
  id: number;
  userId: number;
  points: number;
  purchasesCount: number;
  purchasesUntilReward: number;
  hasAvailableReward: boolean;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}
