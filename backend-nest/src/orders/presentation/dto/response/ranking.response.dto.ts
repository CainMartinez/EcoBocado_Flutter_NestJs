import { ApiProperty } from '@nestjs/swagger';

export class RankingEntryDto {
  @ApiProperty({ example: 1 })
  position: number;

  @ApiProperty({ example: 'Juan Pérez', nullable: true })
  driverName: string | null;

  @ApiProperty({ example: 45 })
  monthlyDeliveries: number;

  @ApiProperty({ example: false })
  isCurrentUser: boolean;
}

export class RankingResponseDto {
  @ApiProperty({ example: '2024-01' })
  currentMonth: string;

  @ApiProperty({ type: [RankingEntryDto] })
  entries: RankingEntryDto[];

  @ApiProperty({ example: 3, nullable: true })
  userPosition: number | null;
}
