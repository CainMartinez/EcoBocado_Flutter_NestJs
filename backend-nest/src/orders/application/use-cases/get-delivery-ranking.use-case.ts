import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { OrderOrmEntity } from '../../infrastructure/typeorm/entities-orm/order.orm-entity';

export interface RankingEntry {
  position: number;
  driverName: string | null;
  monthlyDeliveries: number;
  isCurrentUser: boolean;
}

export interface RankingResponse {
  currentMonth: string;
  entries: RankingEntry[];
  userPosition: number | null;
}

@Injectable()
export class GetDeliveryRankingUseCase {
  constructor(
    @InjectRepository(OrderOrmEntity)
    private readonly orderRepository: Repository<OrderOrmEntity>,
  ) {}

  async execute(currentDriverId: number): Promise<RankingResponse> {
    try {
      console.log('🏆 [RANKING] CurrentDriverId recibido:', currentDriverId);
      
      // Obtener el mes actual
      const now = new Date();
      const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
      console.log('🏆 [RANKING] Mes actual:', currentMonth);

      // Query para obtener el ranking del mes actual desde delivery_drivers
      const rankings = await this.orderRepository
        .createQueryBuilder('order')
        .select('order.driverId', 'driverId')
        .addSelect('driver.name', 'driverName')
        .addSelect('COUNT(order.id)', 'deliveries')
        .leftJoin('delivery_drivers', 'driver', 'driver.id = order.driverId')
        .where('order.status = :status', { status: 'completed' })
        .andWhere('order.driverId IS NOT NULL')
        .andWhere('DATE_FORMAT(order.updatedAt, "%Y-%m") = :currentMonth', { currentMonth })
        .groupBy('order.driverId')
        .addGroupBy('driver.name')
        .orderBy('deliveries', 'DESC')
        .getRawMany();
      
      console.log('🏆 [RANKING] Rankings raw:', JSON.stringify(rankings, null, 2));

      // Construir las entradas del ranking
      const entries: RankingEntry[] = rankings.map((r, index) => {
        const driverIdNum = Number(r.driverId);
        const isCurrentUser = driverIdNum === currentDriverId;
        console.log(`🏆 [RANKING] Comparando driverId:${driverIdNum} (${typeof driverIdNum}) === currentDriverId:${currentDriverId} (${typeof currentDriverId}) => ${isCurrentUser}`);
        
        return {
          position: index + 1,
          driverName: isCurrentUser ? r.driverName : null,
          monthlyDeliveries: Number(r.deliveries),
          isCurrentUser,
        };
      });

      // Encontrar la posición del usuario actual
      const userPosition = entries.findIndex((e) => e.isCurrentUser);
      console.log('🏆 [RANKING] User position:', userPosition !== -1 ? userPosition + 1 : null);

      return {
        currentMonth,
        entries,
        userPosition: userPosition !== -1 ? userPosition + 1 : null,
      };
    } catch (error) {
      console.error('Error al obtener ranking:', error);
      // Retornar respuesta vacía en caso de error
      const now = new Date();
      const currentMonth = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}`;
      return {
        currentMonth,
        entries: [],
        userPosition: null,
      };
    }
  }
}
