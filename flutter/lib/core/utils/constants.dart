import 'package:eco_bocado/core/config/env.dart';

/// URL base leída desde las variables de entorno
final baseUrl = Env.apiBaseUrl;
final publicKeyStripe = Env.publicKeyStripe;

/// Claves para secure storage
const tokenKey = 'access_token';
const refreshKey = 'refresh_token';
const authRoleKey = 'auth_role'; // user o admin