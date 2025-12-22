import { ApiProperty } from '@nestjs/swagger';

export class AllergenResponseDto {
  @ApiProperty({ example: 'gluten', description: 'Código único del alérgeno' })
  code: string;

  @ApiProperty({ example: 'Gluten' })
  nameEs: string;

  @ApiProperty({ example: 'Gluten' })
  nameEn: string;
}
