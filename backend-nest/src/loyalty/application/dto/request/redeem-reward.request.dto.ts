import { IsInt } from 'class-validator';

export class RedeemRewardRequestDto {
  @IsInt()
  rescueMenuId: number;
}
