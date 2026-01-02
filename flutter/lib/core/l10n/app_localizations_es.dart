// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'EcoBocado';

  @override
  String get homePageTitle => 'Comida Deliciosa';

  @override
  String get homePageTitleAccent => 'Sin Desperdicios';

  @override
  String get homePageSubtitle =>
      'Disfruta de la mejor comida para llevar mientras cuidamos nuestro planeta. Envases reutilizables, ingredientes locales y cero desperdicios.';

  @override
  String get badgeZeroWaste => 'Cero Desperdicios';

  @override
  String get badgeVeganMenus => 'Menús Veganos';

  @override
  String get featureEcoFriendlyFood => 'Comida Ecológica';

  @override
  String get featureZeroWaste => 'Zero Waste';

  @override
  String get featureFastPickup => 'Recogida rápida';

  @override
  String get featureNoWaiting => 'Sin esperas';

  @override
  String get featuredCard100Sustainable => '100% Sostenible';

  @override
  String get featuredCardTitle => 'Envases compostables y reutilizables';

  @override
  String get loyaltyBannerTitle =>
      '¡PROGRAMA DE FIDELIDAD! 10 compras = 1 menú GRATIS';

  @override
  String get loyaltyBannerSubtitle =>
      'Acumula puntos y canjéalos por recompensas deliciosas.';

  @override
  String get preferences => 'Preferencias';

  @override
  String get notificationsSection => 'Notificaciones';

  @override
  String get appNotifications => 'Notificaciones en la App';

  @override
  String get emailNotifications => 'Notificaciones por Email';

  @override
  String get whatsappNotifications => 'Notificaciones por WhatsApp';

  @override
  String get appearanceSection => 'Apariencia';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get languageSection => 'Idioma';

  @override
  String get language => 'Idioma';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get viewCatalog => 'Ver Catálogo';

  @override
  String errorLoadingPreferences(String error) {
    return 'Error al cargar preferencias: $error';
  }

  @override
  String get shopPageTitle => 'Menú';

  @override
  String get filterByCategory => 'Categoría';

  @override
  String get allCategories => 'Todas';

  @override
  String get filterByAllergens => 'Alérgenos';

  @override
  String get noAllergensSelected => 'Sin filtrar';

  @override
  String allergensSelectedCount(int count) {
    return '$count seleccionados';
  }

  @override
  String get veganOnly => 'Solo Vegano';

  @override
  String get sortBy => 'Ordenar por';

  @override
  String get sortByNewest => 'Más recientes';

  @override
  String get sortByOldest => 'Más antiguos';

  @override
  String get sortByNameAsc => 'Nombre (A-Z)';

  @override
  String get sortByNameDesc => 'Nombre (Z-A)';

  @override
  String get sortByPriceAsc => 'Precio (menor)';

  @override
  String get sortByPriceDesc => 'Precio (mayor)';

  @override
  String get clearFilters => 'Limpiar filtros';

  @override
  String get applyFilters => 'Aplicar';

  @override
  String get noProductsFound => 'No se encontraron productos';

  @override
  String get tryAdjustingFilters => 'Intenta ajustar los filtros';

  @override
  String get loadingProducts => 'Cargando productos...';

  @override
  String get errorLoadingProducts => 'Error al cargar productos';

  @override
  String get retry => 'Reintentar';

  @override
  String get addToCart => 'Añadir al carrito';

  @override
  String addedToCart(String itemName) {
    return '$itemName añadido al carrito';
  }

  @override
  String get productDetails => 'Detalles del producto';

  @override
  String get description => 'Descripción';

  @override
  String get allergens => 'Alérgenos';

  @override
  String get contains => 'Contiene';

  @override
  String get mayContain => 'Puede contener';

  @override
  String get noAllergens => 'Sin alérgenos declarados';

  @override
  String get menuComposition => 'Composición del menú';

  @override
  String get mainCourse => 'Plato principal';

  @override
  String get sideDish => 'Acompañamiento';

  @override
  String get drink => 'Bebida';

  @override
  String get dessert => 'Postre';

  @override
  String get menuBadge => 'Menú';

  @override
  String get myCart => 'Mi Carrito';

  @override
  String get clearCartTooltip => 'Vaciar carrito';

  @override
  String get emptyCartTitle => 'Tu carrito está vacío';

  @override
  String get emptyCartMessage => 'Añade productos desde el menú';

  @override
  String get viewMenu => 'Ver Menú';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalItems => 'Total de artículos';

  @override
  String get total => 'Total';

  @override
  String get confirmOrder => 'Confirmar Pedido';

  @override
  String get orderPendingImplementation =>
      'Función de pedido pendiente de implementar';

  @override
  String get clearCartDialogTitle => 'Vaciar carrito';

  @override
  String get clearCartDialogMessage =>
      '¿Estás seguro de que deseas eliminar todos los productos del carrito?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get clear => 'Vaciar';

  @override
  String get productManagement => 'Gestión de Productos';

  @override
  String get reload => 'Recargar';

  @override
  String get noProducts => 'No hay productos';

  @override
  String get createFirstProduct => 'Crea tu primer producto usando el botón +';

  @override
  String get newProduct => 'Nuevo Producto';

  @override
  String get createProduct => 'Crear Producto';

  @override
  String get editProduct => 'Editar Producto';

  @override
  String get nameEs => 'Nombre (ES) *';

  @override
  String get nameEn => 'Nombre (EN) *';

  @override
  String get descriptionEs => 'Descripción (ES) *';

  @override
  String get descriptionEn => 'Descripción (EN) *';

  @override
  String get price => 'Precio *';

  @override
  String get isVegan => 'Es vegano';

  @override
  String get category => 'Categoría';

  @override
  String get required => 'Requerido';

  @override
  String get mustBeValidNumber => 'Debe ser un número válido >= 0';

  @override
  String get mustSelectCategory => 'Debes seleccionar una categoría';

  @override
  String get errorSelectingImages => 'Error al seleccionar imágenes';

  @override
  String get errorDeletingImage => 'Error al eliminar imagen';

  @override
  String get errorUploadingImage => 'Error al subir imagen';

  @override
  String get errorUpdatingAllergens => 'Error al actualizar alérgenos';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get productCreatedSuccessfully => 'Producto creado correctamente';

  @override
  String get productUpdatedSuccessfully => 'Producto actualizado correctamente';

  @override
  String get create => 'Crear';

  @override
  String get update => 'Actualizar';

  @override
  String get noAllergensAvailable => 'No hay alérgenos disponibles';

  @override
  String get allergensOptional => 'Alérgenos (opcional)';

  @override
  String get selectAllergens =>
      'Selecciona los alérgenos que aplican a este producto:';

  @override
  String get imagesOptional => 'Imágenes (opcional)';

  @override
  String get existingImages => 'Imágenes existentes:';

  @override
  String get addImages => 'Añadir imágenes';

  @override
  String get selectedImagesWillBeUploaded =>
      'Imágenes seleccionadas (se subirán al guardar):';

  @override
  String get reactivate => 'Reactivar';

  @override
  String get productReactivated => 'Producto reactivado';

  @override
  String get errorReactivatingProduct => 'Error al reactivar el producto';

  @override
  String get deactivate => 'Desactivar';

  @override
  String get confirmDeactivation => 'Confirmar desactivación';

  @override
  String confirmDeactivationMessage(String productName) {
    return '¿Estás seguro de que deseas desactivar el producto \'$productName\'?';
  }

  @override
  String get productDeactivated => 'Producto desactivado';

  @override
  String get errorDeactivatingProduct => 'Error al desactivar el producto';

  @override
  String get vegan => 'Vegano';

  @override
  String get active => 'Activo';

  @override
  String get inactive => 'Inactivo';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String get hello => 'Hola';

  @override
  String get dashboard => 'Panel de Control';

  @override
  String get products => 'Productos';

  @override
  String get billing => 'Facturación';

  @override
  String get profile => 'Perfil';

  @override
  String get home => 'Inicio';

  @override
  String get menu => 'Menú';

  @override
  String get orders => 'Pedidos';

  @override
  String fieldRequired(String field) {
    return '$field es obligatorio';
  }

  @override
  String get emailRequired => 'El email es obligatorio';

  @override
  String get invalidEmail => 'Email no válido';

  @override
  String get passwordRequired => 'La contraseña es obligatoria';

  @override
  String get passwordMinLength => 'Mínimo 8 caracteres';

  @override
  String get passwordUppercase => 'Debe contener al menos una mayúscula';

  @override
  String get passwordLowercase => 'Debe contener al menos una minúscula';

  @override
  String get passwordNumber => 'Debe contener al menos un número';

  @override
  String get passwordSpecialChar =>
      'Debe contener al menos un carácter especial';

  @override
  String get confirmPasswordRequired => 'Confirma tu contraseña';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get nameRequired => 'El nombre es obligatorio';

  @override
  String get nameTooShort => 'Nombre demasiado corto';

  @override
  String get myProfile => 'Mi Perfil';

  @override
  String get administrator => 'Administrador';

  @override
  String get user => 'Usuario';

  @override
  String get personalInfo => 'Información Personal';

  @override
  String get phone => 'Teléfono';

  @override
  String get notProvided => 'No proporcionado';

  @override
  String get address => 'Dirección';

  @override
  String get city => 'Ciudad';

  @override
  String get postalCode => 'Código Postal';

  @override
  String get country => 'País';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get errorLoadingProfile => 'Error al cargar perfil';

  @override
  String get logoutConfirmTitle => 'Cerrar Sesión';

  @override
  String get logoutConfirmMessage =>
      '¿Estás seguro de que deseas cerrar sesión?';

  @override
  String get errorLoggingOut => 'Error al cerrar sesión';

  @override
  String get avatarUrl => 'URL del Avatar';

  @override
  String get addressLine1 => 'Dirección (Línea 1)';

  @override
  String get addressLine2 => 'Dirección (Línea 2)';

  @override
  String get countryCode => 'Código de País';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get profileUpdatedSuccessfully => 'Perfil actualizado correctamente';

  @override
  String get errorUpdatingProfile => 'Error al actualizar perfil';

  @override
  String get currentPassword => 'Contraseña Actual';

  @override
  String get newPassword => 'Nueva Contraseña';

  @override
  String get confirmNewPassword => 'Confirmar Nueva Contraseña';

  @override
  String get passwordRequirements =>
      'La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas, números y caracteres especiales.';

  @override
  String get passwordUpdatedSuccessfully =>
      'Contraseña actualizada correctamente';

  @override
  String get errorChangingPassword => 'Error al cambiar contraseña';

  @override
  String get errorUserNotFound => 'No existe un usuario con ese email';

  @override
  String get errorInvalidPassword => 'La contraseña introducida es incorrecta';

  @override
  String get errorEmailAlreadyInUse => 'Este email ya está registrado';

  @override
  String get errorWeakPassword =>
      'La contraseña no cumple los requisitos de seguridad';

  @override
  String get errorUnauthorized =>
      'No estás autenticado. Por favor, inicia sesión';

  @override
  String get errorForbidden => 'No tienes permisos para realizar esta acción';

  @override
  String get errorTokenExpired =>
      'Tu sesión ha caducado. Por favor, inicia sesión de nuevo';

  @override
  String get errorInvalidToken =>
      'Token inválido. Por favor, inicia sesión de nuevo';

  @override
  String get errorTokenNotProvided =>
      'No se proporcionó token de autenticación';

  @override
  String get errorNotFound => 'El recurso solicitado no se encontró';

  @override
  String get errorBadRequest => 'La solicitud contiene datos inválidos';

  @override
  String get errorInternalServer =>
      'Error interno del servidor. Inténtalo más tarde';

  @override
  String get errorNetwork => 'Error de conexión. Verifica tu internet';

  @override
  String get errorGeneric => 'Ha ocurrido un error. Inténtalo de nuevo';

  @override
  String get loginTitle => 'Inicia sesión';

  @override
  String get registerTitle => 'Crea tu cuenta';

  @override
  String get authSubtitle => 'Comidas zero waste, recogida sin esperas.';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Registro';

  @override
  String get clientRole => 'Cliente';

  @override
  String get adminRole => 'Admin';

  @override
  String get loggingIn => 'Entrando...';

  @override
  String get login => 'Entrar';

  @override
  String get creatingAccount => 'Creando cuenta...';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get password => 'Contraseña';

  @override
  String get authAcceptTerms =>
      'Al continuar aceptas la recogida rápida y el sistema de puntos.';

  @override
  String registerSuccessMessage(String name, String email) {
    return '¡Te has registrado con éxito $name con el email $email!';
  }

  @override
  String get errorLoginFailed => 'No se pudo iniciar sesión';

  @override
  String get errorRegisterFailed => 'Error en el registro';

  @override
  String get clearFilter => 'Limpiar filtro';

  @override
  String get noProductsInCategory => 'No hay productos en esta categoría';

  @override
  String get tryAnotherCategory => 'Prueba con otra categoría';

  @override
  String get loadingCategories => 'Cargando categorías...';

  @override
  String get searchProducts => 'Buscar productos...';

  @override
  String get overview => 'Resumen General';

  @override
  String get totalOrders => 'Pedidos Totales';

  @override
  String get revenue => 'Ingresos';

  @override
  String get users => 'Usuarios';

  @override
  String get recentOrders => 'Pedidos Recientes';

  @override
  String get noRecentOrders => 'No hay pedidos recientes';

  @override
  String get ordersWillAppearHere =>
      'Los pedidos aparecerán aquí cuando los clientes hagan compras';

  @override
  String get topProducts => 'Productos Más Vendidos';

  @override
  String get noSalesData => 'No hay datos de ventas';

  @override
  String get salesDataWillAppearHere =>
      'Los datos de ventas aparecerán aquí cuando se realicen compras';

  @override
  String get noBillingRecords => 'No hay registros de facturación';

  @override
  String get billingRecordsWillAppearHere =>
      'Los registros de facturación aparecerán aquí';

  @override
  String get errorLoadingBillingRecords =>
      'Error al cargar registros de facturación';

  @override
  String get customer => 'Cliente';

  @override
  String get email => 'Email';

  @override
  String get issuedAt => 'Emitida el';

  @override
  String get order => 'Pedido';

  @override
  String get status => 'Estado';

  @override
  String get statusRequested => 'Solicitada';

  @override
  String get statusIssued => 'Emitida';

  @override
  String get statusCancelled => 'Cancelada';

  @override
  String get createdAt => 'Creada el';
}
