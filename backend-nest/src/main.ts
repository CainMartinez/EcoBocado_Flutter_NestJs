import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { DomainExceptionFilter } from './shared/presentation/filters/domain-exception.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.enableCors({
    origin: true, // Permite todas las origenes en desarrollo
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  });
  
  app.setGlobalPrefix('api');
  app.useGlobalFilters(new DomainExceptionFilter());
  
  const config = new DocumentBuilder()
    .setTitle('Zero Waste EcoBocado API')
    .setDescription('Documentación interactiva de los endpoints de Zero Waste EcoBocado.')
    .setVersion('3.5.4')
    .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' , description: 'Ingrese el access token JWT sin el "Bearer"'})
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  const port = process.env.PORT || 3000;
  await app.listen(port);
}
bootstrap();