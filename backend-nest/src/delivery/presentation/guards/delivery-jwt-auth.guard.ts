import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class DeliveryJwtAuthGuard extends AuthGuard('delivery-jwt') {
  canActivate(context: ExecutionContext) {
    return super.canActivate(context);
  }
}
