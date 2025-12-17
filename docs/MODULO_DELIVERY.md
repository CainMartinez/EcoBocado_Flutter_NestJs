# Módulo de Repartidor (Delivery Driver)

## Backend - NestJS

### Descripción
Módulo completo para la gestión de repartidores con autenticación JWT sin refresh token (token de 8 horas de duración).

### Estructura del Módulo

```
backend-nest/src/delivery/
├── domain/
│   ├── entities/
│   │   └── delivery-driver.entity.ts       # Entidad de dominio del repartidor
│   ├── repositories/
│   │   └── delivery-driver.repository.ts   # Interface del repositorio
│   └── exceptions/
│       ├── delivery-driver-not-found.exception.ts
│       └── invalid-password.exception.ts
├── application/
│   ├── use_cases/
│   │   ├── delivery-login.usecase.ts       # Login de repartidor
│   │   ├── get-delivery-profile.usecase.ts # Obtener perfil
│   │   └── update-availability.usecase.ts  # Actualizar disponibilidad
│   └── dto/
│       ├── request/
│       │   └── delivery-login.request.dto.ts
│       └── response/
│           └── delivery-login.response.dto.ts
├── infrastructure/
│   ├── typeorm/
│   │   ├── entities-orm/
│   │   │   └── delivery-driver.orm-entity.ts
│   │   └── repositories/
│   │       └── delivery-driver.typeorm.repository.ts
│   ├── token/
│   │   └── delivery-jwt-token.service.ts   # Servicio JWT específico (8h)
│   └── strategies/
│       └── delivery-jwt.strategy.ts        # Estrategia Passport JWT
├── presentation/
│   ├── controllers/
│   │   ├── delivery-login.controller.ts
│   │   └── delivery-profile.controller.ts
│   ├── assemblers/
│   │   └── delivery-driver-public.assembler.ts
│   └── guards/
│       └── delivery-jwt-auth.guard.ts
└── delivery.module.ts
```

### Endpoints

#### POST /delivery/auth/register
Registrar un nuevo repartidor. **Solo debe ser accesible desde el panel de administración, no desde la app móvil.**

**Request:**
```json
{
  "email": "driver@test.com",
  "name": "Juan Repartidor",
  "phone": "+34666777888",
  "password": "delivery123",
  "vehicleType": "motorcycle",
  "vehiclePlate": "ABC1234"
}
```

**Response:**
```json
{
  "id": 1,
  "uuid": "123e4567-e89b-12d3-a456-426614174000",
  "email": "driver@test.com",
  "name": "Juan Repartidor",
  "phone": "+34666777888",
  "avatarUrl": null,
  "isAvailable": false,
  "vehicleType": "motorcycle",
  "vehiclePlate": "ABC1234",
  "createdAt": "2025-12-17T10:30:00.000Z"
}
```

**Validaciones:**
- Email debe ser válido y único
- Nombre mínimo 2 caracteres
- Teléfono mínimo 9 caracteres
- Contraseña mínimo 6 caracteres
- vehicleType: 'bike', 'motorcycle', o 'car' (opcional)
- vehiclePlate: opcional

#### POST /delivery/auth/login
Login de repartidor. Retorna un access token con duración de 8 horas.

**Request:**
```json
{
  "email": "driver@test.com",
  "password": "delivery123"
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 1671234567,
  "driver": {
    "id": 1,
    "uuid": "123e4567-e89b-12d3-a456-426614174000",
    "email": "driver@test.com",
    "name": "Juan Repartidor",
    "phone": "+34666777888",
    "avatarUrl": null,
    "isAvailable": true,
    "vehicleType": "motorcycle",
    "vehiclePlate": "ABC1234"
  }
}
```

#### GET /delivery/profile/me
Obtener perfil del repartidor autenticado.

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "id": 1,
  "uuid": "123e4567-e89b-12d3-a456-426614174000",
  "email": "driver@test.com",
  "name": "Juan Repartidor",
  "phone": "+34666777888",
  "avatarUrl": null,
  "isAvailable": true,
  "vehicleType": "motorcycle",
  "vehiclePlate": "ABC1234"
}
```

#### PATCH /delivery/profile/availability
Actualizar disponibilidad del repartidor.

**Headers:**
5. **Registro restringido**: El endpoint de registro NO está implementado en React Native por seguridad. Solo debe ser accesible desde el panel de administración.
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "isAvailable": true
}
```

**Response:**
```json
{
  "id": 1,
  "uuid": "123e4567-e89b-12d3-a456-426614174000",
  "email": "driver@test.com",
  "name": "Juan Repartidor",
  "phone": "+34666777888",
  "avatarUrl": null,
  "isAvailable": true,
  "vehicleType": "motorcycle",
  "vehiclePlate": "ABC1234"
}
```

### Base de Datos

Ejecutar el script SQL para crear la tabla:
```bash
mysql -u root -p zero_waste_db < database/delivery_drivers_seed.sql
```

### Características Especiales

1. **Sin Refresh Token**: Los repartidores solo tienen access token con duración de 8 horas
2. **Tipo de propietario**: El JWT incluye `ownerType: 'delivery'` para diferenciarlo de usuarios y admins
3. **Guard específico**: `DeliveryJwtAuthGuard` valida que el token sea de tipo delivery
4. **Disponibilidad**: Los repartidores pueden marcar su disponibilidad para recibir pedidos
5. **Registro restringido**: El endpoint de registro NO está implementado en React Native por seguridad. Solo debe ser accesible desde el panel de administración.
6. **Documentación Swagger**: Todos los endpoints están completamente documentados con decoradores de Swagger/OpenAPI

### Documentación API (Swagger)

El módulo de delivery está completamente documentado con Swagger. Para acceder a la documentación interactiva:

1. Iniciar el servidor: `npm run start:dev`
2. Abrir en el navegador: `http://localhost:3000/api`
3. Buscar las secciones:
   - **Delivery - Autenticación**: Login y registro de repartidores
   - **Delivery - Perfil**: Gestión de perfil y disponibilidad

La documentación incluye:
- ✅ Descripciones detalladas de cada endpoint
- ✅ Ejemplos de request y response
- ✅ Códigos de estado HTTP
- ✅ Esquemas de validación
- ✅ Errores posibles con ejemplos
- ✅ Rate limiting (login: 5 intentos/minuto)
- ✅ Autenticación Bearer Token

---

## Frontend - React Native

### Gestión de Estado Global con Zustand

Se ha configurado Zustand como gestor de estado global con las siguientes stores:

#### 1. **deliveryAuthStore** - Autenticación de Repartidores
```typescript
import { useDeliveryAuthStore } from '@/stores/deliveryAuthStore';

// Uso en componentes
const { driver, isAuthenticated, setAuth, logout } = useDeliveryAuthStore();

// Login
setAuth(accessToken, expiresIn, driver);

// Logout
logout();

// Actualizar datos del repartidor
updateDriver({ isAvailable: true });
```

#### 2. **authStore** - Autenticación de Usuarios
```typescript
import { useAuthStore } from '@/stores/authStore';

const { user, isAuthenticated, setAuth, logout } = useAuthStore();
```

#### 3. **cartStore** - Carrito de Compras
```typescript
import { useCartStore } from '@/stores/cartStore';

const { items, totalPrice, addItem, removeItem, updateQuantity, clearCart } = useCartStore();

// Agregar producto
addItem({
  id: 1,
  productId: 123,
  name: 'Producto',
  price: 10.99,
  quantity: 2
});
```

### Validaciones con Zod y React Hook Form

#### Schemas disponibles:

1. **authSchemas.ts** - Login, registro, cambio de contraseña
2. **deliverySchemas.ts** - Login de repartidor, disponibilidad
3. **profileSchemas.ts** - Actualización de perfil, direcciones

#### Ejemplo de uso:

```typescript
import { useForm, Controller } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { deliveryLoginSchema, DeliveryLoginFormData } from '@/schemas/deliverySchemas';

const {
  control,
  handleSubmit,
  formState: { errors },
} = useForm<DeliveryLoginFormData>({
  resolver: zodResolver(deliveryLoginSchema),
  defaultValues: {
    email: '',
    password: '',
  },
});

const onSubmit = async (data: DeliveryLoginFormData) => {
  const response = await deliveryService.login(data);
  setAuth(response.accessToken, response.expiresIn, response.driver);
};
```

### Servicios API

#### deliveryService.ts
```typescript
import { deliveryService } from '@/services/deliveryService';

// Login
const response = await deliveryService.login({ email, password });

// Obtener perfil
const profile = await deliveryService.getProfile(accessToken);

// Actualizar disponibilidad
const updated = await deliveryService.updateAvailability(
  { isAvailable: true },
  accessToken
);
```

### Configuración de Variables de Entorno

Crear un archivo `.env` en la raíz del proyecto React Native:

```env
EXPO_PUBLIC_API_URL=http://localhost:3000
```

Para producción:
```env
EXPO_PUBLIC_API_URL=https://api.tudominio.com
```

### Dependencias Instaladas

```json
{
  "dependencies": {
    "zustand": "^4.x.x",
    "react-hook-form": "^7.x.x",
    "zod": "^3.x.x",
    "@hookform/resolvers": "^3.x.x",
    "@react-native-async-storage/async-storage": "^1.x.x",
    "axios": "^1.x.x"
  }
}
```

### Componente de Ejemplo

El componente `DeliveryLoginScreen.tsx` muestra cómo integrar:
- React Hook Form
- Validación con Zod
- Zustand para estado global
- Axios para llamadas API
- Manejo de errores

```typescript
import DeliveryLoginScreen from '@/components/DeliveryLoginScreen';
```

### Próximos Pasos

1. Implementar navegación con React Navigation
2. Crear pantallas para gestión de pedidos del repartidor
3. Implementar notificaciones push para nuevos pedidos
4. Agregar tracking en tiempo real con WebSockets
5. Implementar persistencia de sesión con AsyncStorage

### Notas Importantes

- Los tokens de repartidor expiran en 8 horas (sin refresh)
- Se recomienda implementar un sistema de renovación automática antes de expirar
- El store de delivery usa AsyncStorage para persistir la sesión
- Validar siempre en el backend el tipo de usuario (ownerType: 'delivery')
