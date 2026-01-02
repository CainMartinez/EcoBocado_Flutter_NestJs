import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as Minio from 'minio';

@Injectable()
export class MinioClientService {
  private readonly minioClient: Minio.Client;
  private readonly buckets = {
    products: 'products',
    menus: 'menus',
    userAvatars: 'user-avatars',
    adminAvatars: 'admin-avatars',
  };
  private readonly logger = new Logger(MinioClientService.name);

  constructor(private readonly configService: ConfigService) {
    this.minioClient = new Minio.Client({
      endPoint: this.configService.get<string>('MINIO_ENDPOINT') || 'localhost',
      port: parseInt(this.configService.get<string>('MINIO_PORT') || '9000', 10),
      useSSL: this.configService.get<string>('MINIO_USE_SSL') === 'true',
      accessKey: this.configService.get<string>('MINIO_ACCESS_KEY') || 'admin',
      secretKey: this.configService.get<string>('MINIO_SECRET_KEY') || 'admin',
    });

    this.initializeBuckets();
  }

  /**
   * Inicializa los buckets necesarios
   */
  private async initializeBuckets() {
    for (const [key, bucketName] of Object.entries(this.buckets)) {
      try {
        const exists = await this.minioClient.bucketExists(bucketName);
        if (!exists) {
          await this.minioClient.makeBucket(bucketName, 'us-east-1');
          
          // Configurar política pública para lectura
          const policy = {
            Version: '2012-10-17',
            Statement: [
              {
                Effect: 'Allow',
                Principal: { AWS: ['*'] },
                Action: ['s3:GetObject'],
                Resource: [`arn:aws:s3:::${bucketName}/*`],
              },
            ],
          };
          await this.minioClient.setBucketPolicy(bucketName, JSON.stringify(policy));
          
          this.logger.log(`Bucket ${bucketName} created successfully`);
        }
      } catch (error) {
        this.logger.error(`Error initializing bucket ${bucketName}:`, error);
      }
    }
  }

  /**
   * Sube un archivo a MinIO y retorna el slug y path relativo
   */
  async uploadFile(
    file: Express.Multer.File,
    type: 'product' | 'menu' | 'user-avatar' | 'admin-avatar',
  ): Promise<{ slug: string; fileName: string; path: string }> {
    let bucket: string;
    
    // Mapear tipo a bucket
    if (type === 'product') {
      bucket = this.buckets.products;
    } else if (type === 'menu') {
      bucket = this.buckets.menus;
    } else if (type === 'user-avatar') {
      bucket = this.buckets.userAvatars;
    } else if (type === 'admin-avatar') {
      bucket = this.buckets.adminAvatars;
    } else {
      bucket = this.buckets.products;
    }
    
    const timestamp = Date.now();
    const sanitizedName = file.originalname.replace(/\s+/g, '-').toLowerCase();
    const fileName = `${timestamp}-${sanitizedName}`;
    
    // Generar slug: {bucket}-{timestamp}-{nombre}
    const slug = `${bucket}-${timestamp}-${sanitizedName}`;
    
    // Path relativo: /images/{bucket}/{fileName}
    const path = `/${bucket}/${fileName}`;

    try {
      await this.minioClient.putObject(
        bucket,
        fileName,
        file.buffer,
        file.size,
        { 'Content-Type': file.mimetype },
      );
      
      this.logger.log(`File uploaded: ${fileName} to bucket ${bucket} with slug ${slug}`);
      return { slug, fileName, path };
    } catch (error) {
      this.logger.error(`Error uploading file:`, error);
      throw error;
    }
  }

  /**
   * Obtiene el stream de un archivo
   */
  async getFileStream(bucket: string, fileName: string) {
    try {
      return await this.minioClient.getObject(bucket, fileName);
    } catch (error) {
      this.logger.error(`Error getting file stream:`, error);
      throw error;
    }
  }

  /**
   * Elimina un archivo de MinIO
   */
  async deleteFile(bucket: string, fileName: string): Promise<void> {
    try {
      await this.minioClient.removeObject(bucket, fileName);
      this.logger.log(`File deleted: ${fileName} from bucket ${bucket}`);
    } catch (error) {
      this.logger.error(`Error deleting file:`, error);
      throw error;
    }
  }

  /**
   * Obtiene una URL pre-firmada (válida por 7 días por defecto)
   */
  async getPresignedUrl(
    bucket: string,
    fileName: string,
    expiry: number = 7 * 24 * 60 * 60, // 7 días
  ): Promise<string> {
    try {
      return await this.minioClient.presignedGetObject(bucket, fileName, expiry);
    } catch (error) {
      this.logger.error(`Error getting presigned URL:`, error);
      throw error;
    }
  }

  /**
   * Obtiene la URL base pública de MinIO desde env
   */
  getPublicBaseUrl(): string {
    return this.configService.get<string>('MINIO_PUBLIC_URL') || 'http://localhost:9000';
  }

  /**
   * Obtiene el nombre del bucket según el tipo
   */
  getBucketName(type: 'product' | 'menu'): string {
    return this.buckets[`${type}s`];
  }
}
