import { Injectable, ExecutionContext } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * Guard JWT opcional - permite el acceso sin token pero agrega req.user si existe
 * Útil para endpoints que funcionan con o sin autenticación
 */
@Injectable()
export class OptionalJwtAuthGuard extends AuthGuard('jwt') {
  /**
   * Sobreescribir handleRequest para no lanzar error cuando no hay token
   */
  handleRequest(err: any, user: any, info: any, context: ExecutionContext) {
    // Si hay error o no hay usuario, simplemente devolver null (no autenticado)
    // NO lanzar excepción - permitir que la request continúe
    if (err || !user) {
      return null;
    }
    
    return user;
  }
}
