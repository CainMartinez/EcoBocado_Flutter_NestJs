export class LoyaltyRedemptionResponseDto {
  id: number;
  userId: number;
  ruleId: number;
  rescueMenuId: number;
  rescueMenuName: string;
  orderId: number | null;
  redeemedAt: Date;
  isActive: boolean;
}
