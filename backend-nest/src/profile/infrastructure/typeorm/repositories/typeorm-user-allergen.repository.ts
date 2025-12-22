import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { UserAllergenOrmEntity } from '../entities-orm/user-allergen.orm-entity';
import { IUserAllergenRepository } from '../../../domain/repositories/user-allergen.repository.interface';
import { UserAllergen } from '../../../domain/entities/user-allergen.entity';

@Injectable()
export class TypeOrmUserAllergenRepository implements IUserAllergenRepository {
  constructor(
    @InjectRepository(UserAllergenOrmEntity)
    private readonly userAllergenRepo: Repository<UserAllergenOrmEntity>,
  ) {}

  async add(userId: number, allergenCode: string): Promise<UserAllergen> {
    // Intentar insertar, si ya existe no hacer nada
    const existing = await this.userAllergenRepo.findOne({
      where: { userId, allergenCode },
    });

    if (existing) {
      return UserAllergen.fromPrimitives({
        id: existing.id,
        userId: existing.userId,
        allergenCode: existing.allergenCode,
        createdAt: existing.createdAt,
      });
    }

    const userAllergen = this.userAllergenRepo.create({
      userId,
      allergenCode,
    });

    const saved = await this.userAllergenRepo.save(userAllergen);

    return UserAllergen.fromPrimitives({
      id: saved.id,
      userId: saved.userId,
      allergenCode: saved.allergenCode,
      createdAt: saved.createdAt,
    });
  }

  async remove(userId: number, allergenCode: string): Promise<void> {
    await this.userAllergenRepo.delete({ userId, allergenCode });
  }

  async findAllergenCodesByUserId(userId: number): Promise<string[]> {
    const userAllergens = await this.userAllergenRepo.find({
      where: { userId },
      select: ['allergenCode'],
    });

    return userAllergens.map((ua) => ua.allergenCode);
  }

  async hasAllergen(userId: number, allergenCode: string): Promise<boolean> {
    const count = await this.userAllergenRepo.count({
      where: { userId, allergenCode },
    });

    return count > 0;
  }
}
