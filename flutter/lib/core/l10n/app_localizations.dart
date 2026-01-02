import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Nombre de la aplicación
  ///
  /// In es, this message translates to:
  /// **'EcoBocado'**
  String get appTitle;

  /// Título principal de la página de inicio
  ///
  /// In es, this message translates to:
  /// **'Comida Deliciosa'**
  String get homePageTitle;

  /// Título secundario destacado de la página de inicio
  ///
  /// In es, this message translates to:
  /// **'Sin Desperdicios'**
  String get homePageTitleAccent;

  /// Subtítulo descriptivo de la página de inicio
  ///
  /// In es, this message translates to:
  /// **'Disfruta de la mejor comida para llevar mientras cuidamos nuestro planeta. Envases reutilizables, ingredientes locales y cero desperdicios.'**
  String get homePageSubtitle;

  /// Badge de cero desperdicios
  ///
  /// In es, this message translates to:
  /// **'Cero Desperdicios'**
  String get badgeZeroWaste;

  /// Badge de menús veganos
  ///
  /// In es, this message translates to:
  /// **'Menús Veganos'**
  String get badgeVeganMenus;

  /// Característica de comida ecológica
  ///
  /// In es, this message translates to:
  /// **'Comida Ecológica'**
  String get featureEcoFriendlyFood;

  /// Descripción corta de zero waste
  ///
  /// In es, this message translates to:
  /// **'Zero Waste'**
  String get featureZeroWaste;

  /// Característica de recogida rápida
  ///
  /// In es, this message translates to:
  /// **'Recogida rápida'**
  String get featureFastPickup;

  /// Descripción de sin esperas
  ///
  /// In es, this message translates to:
  /// **'Sin esperas'**
  String get featureNoWaiting;

  /// Badge de 100% sostenible
  ///
  /// In es, this message translates to:
  /// **'100% Sostenible'**
  String get featuredCard100Sustainable;

  /// Título de la tarjeta destacada
  ///
  /// In es, this message translates to:
  /// **'Envases compostables y reutilizables'**
  String get featuredCardTitle;

  /// Título del banner de fidelidad
  ///
  /// In es, this message translates to:
  /// **'¡PROGRAMA DE FIDELIDAD! 10 compras = 1 menú GRATIS'**
  String get loyaltyBannerTitle;

  /// Subtítulo del banner de fidelidad
  ///
  /// In es, this message translates to:
  /// **'Acumula puntos y canjéalos por recompensas deliciosas.'**
  String get loyaltyBannerSubtitle;

  /// Tooltip preferencias
  ///
  /// In es, this message translates to:
  /// **'Preferencias'**
  String get preferences;

  /// Título de la sección de notificaciones
  ///
  /// In es, this message translates to:
  /// **'Notificaciones'**
  String get notificationsSection;

  /// Toggle de notificaciones en la app
  ///
  /// In es, this message translates to:
  /// **'Notificaciones en la App'**
  String get appNotifications;

  /// Toggle de notificaciones por email
  ///
  /// In es, this message translates to:
  /// **'Notificaciones por Email'**
  String get emailNotifications;

  /// Toggle de notificaciones por WhatsApp
  ///
  /// In es, this message translates to:
  /// **'Notificaciones por WhatsApp'**
  String get whatsappNotifications;

  /// Título de la sección de apariencia
  ///
  /// In es, this message translates to:
  /// **'Apariencia'**
  String get appearanceSection;

  /// Toggle de modo oscuro
  ///
  /// In es, this message translates to:
  /// **'Modo Oscuro'**
  String get darkMode;

  /// Título de la sección de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get languageSection;

  /// Label del selector de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Opción de idioma español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// Opción de idioma inglés
  ///
  /// In es, this message translates to:
  /// **'Inglés'**
  String get languageEnglish;

  /// Botón para ver el catálogo
  ///
  /// In es, this message translates to:
  /// **'Ver Catálogo'**
  String get viewCatalog;

  /// Error al cargar preferencias con parámetro dinámico
  ///
  /// In es, this message translates to:
  /// **'Error al cargar preferencias: {error}'**
  String errorLoadingPreferences(String error);

  /// Título de la página del menú/catálogo
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get shopPageTitle;

  /// Label del filtro por categoría
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get filterByCategory;

  /// Opción para mostrar todas las categorías
  ///
  /// In es, this message translates to:
  /// **'Todas'**
  String get allCategories;

  /// Label del filtro de alérgenos
  ///
  /// In es, this message translates to:
  /// **'Alérgenos'**
  String get filterByAllergens;

  /// Texto cuando no hay alérgenos seleccionados
  ///
  /// In es, this message translates to:
  /// **'Sin filtrar'**
  String get noAllergensSelected;

  /// Contador de alérgenos seleccionados
  ///
  /// In es, this message translates to:
  /// **'{count} seleccionados'**
  String allergensSelectedCount(int count);

  /// Filtro para mostrar solo productos veganos
  ///
  /// In es, this message translates to:
  /// **'Solo Vegano'**
  String get veganOnly;

  /// Label del selector de ordenamiento
  ///
  /// In es, this message translates to:
  /// **'Ordenar por'**
  String get sortBy;

  /// Ordenar por más recientes
  ///
  /// In es, this message translates to:
  /// **'Más recientes'**
  String get sortByNewest;

  /// Ordenar por más antiguos
  ///
  /// In es, this message translates to:
  /// **'Más antiguos'**
  String get sortByOldest;

  /// Ordenar por nombre ascendente
  ///
  /// In es, this message translates to:
  /// **'Nombre (A-Z)'**
  String get sortByNameAsc;

  /// Ordenar por nombre descendente
  ///
  /// In es, this message translates to:
  /// **'Nombre (Z-A)'**
  String get sortByNameDesc;

  /// Ordenar por precio ascendente
  ///
  /// In es, this message translates to:
  /// **'Precio (menor)'**
  String get sortByPriceAsc;

  /// Ordenar por precio descendente
  ///
  /// In es, this message translates to:
  /// **'Precio (mayor)'**
  String get sortByPriceDesc;

  /// Botón para limpiar todos los filtros
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtros'**
  String get clearFilters;

  /// Botón para aplicar filtros
  ///
  /// In es, this message translates to:
  /// **'Aplicar'**
  String get applyFilters;

  /// Mensaje cuando no hay productos con los filtros aplicados
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get noProductsFound;

  /// Sugerencia cuando no hay resultados
  ///
  /// In es, this message translates to:
  /// **'Intenta ajustar los filtros'**
  String get tryAdjustingFilters;

  /// Mensaje de carga de productos
  ///
  /// In es, this message translates to:
  /// **'Cargando productos...'**
  String get loadingProducts;

  /// Mensaje de error al cargar productos
  ///
  /// In es, this message translates to:
  /// **'Error al cargar productos'**
  String get errorLoadingProducts;

  /// Botón para reintentar acción
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Botón para añadir producto al carrito
  ///
  /// In es, this message translates to:
  /// **'Añadir al carrito'**
  String get addToCart;

  /// Mensaje de confirmación al añadir al carrito
  ///
  /// In es, this message translates to:
  /// **'{itemName} añadido al carrito'**
  String addedToCart(String itemName);

  /// Título del modal de detalles
  ///
  /// In es, this message translates to:
  /// **'Detalles del producto'**
  String get productDetails;

  /// Label de descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// Label de alérgenos
  ///
  /// In es, this message translates to:
  /// **'Alérgenos'**
  String get allergens;

  /// Indica que contiene un alérgeno
  ///
  /// In es, this message translates to:
  /// **'Contiene'**
  String get contains;

  /// Indica que puede contener un alérgeno
  ///
  /// In es, this message translates to:
  /// **'Puede contener'**
  String get mayContain;

  /// Mensaje cuando no hay alérgenos
  ///
  /// In es, this message translates to:
  /// **'Sin alérgenos declarados'**
  String get noAllergens;

  /// Título de la sección de composición del menú
  ///
  /// In es, this message translates to:
  /// **'Composición del menú'**
  String get menuComposition;

  /// Label de plato principal
  ///
  /// In es, this message translates to:
  /// **'Plato principal'**
  String get mainCourse;

  /// Label de acompañamiento
  ///
  /// In es, this message translates to:
  /// **'Acompañamiento'**
  String get sideDish;

  /// Label de bebida
  ///
  /// In es, this message translates to:
  /// **'Bebida'**
  String get drink;

  /// Label de postre
  ///
  /// In es, this message translates to:
  /// **'Postre'**
  String get dessert;

  /// Badge que indica que es un menú
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get menuBadge;

  /// Título de la página del carrito
  ///
  /// In es, this message translates to:
  /// **'Mi Carrito'**
  String get myCart;

  /// Tooltip del botón para vaciar carrito
  ///
  /// In es, this message translates to:
  /// **'Vaciar carrito'**
  String get clearCartTooltip;

  /// Título mostrado cuando el carrito está vacío
  ///
  /// In es, this message translates to:
  /// **'Tu carrito está vacío'**
  String get emptyCartTitle;

  /// Mensaje mostrado cuando el carrito está vacío
  ///
  /// In es, this message translates to:
  /// **'Añade productos desde el menú'**
  String get emptyCartMessage;

  /// Botón para navegar al menú/shop
  ///
  /// In es, this message translates to:
  /// **'Ver Menú'**
  String get viewMenu;

  /// Label de subtotal en el resumen del carrito
  ///
  /// In es, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Label del contador de artículos
  ///
  /// In es, this message translates to:
  /// **'Total de artículos'**
  String get totalItems;

  /// Label del precio total
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// Botón para confirmar pedido
  ///
  /// In es, this message translates to:
  /// **'Confirmar Pedido'**
  String get confirmOrder;

  /// Mensaje mostrado cuando la función de pedido no está implementada
  ///
  /// In es, this message translates to:
  /// **'Función de pedido pendiente de implementar'**
  String get orderPendingImplementation;

  /// Título del diálogo de confirmación para vaciar carrito
  ///
  /// In es, this message translates to:
  /// **'Vaciar carrito'**
  String get clearCartDialogTitle;

  /// Mensaje del diálogo de confirmación para vaciar carrito
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas eliminar todos los productos del carrito?'**
  String get clearCartDialogMessage;

  /// Texto del botón cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Texto del botón vaciar
  ///
  /// In es, this message translates to:
  /// **'Vaciar'**
  String get clear;

  /// Título de la página de administración de productos
  ///
  /// In es, this message translates to:
  /// **'Gestión de Productos'**
  String get productManagement;

  /// Tooltip del botón recargar
  ///
  /// In es, this message translates to:
  /// **'Recargar'**
  String get reload;

  /// Mensaje cuando no hay productos
  ///
  /// In es, this message translates to:
  /// **'No hay productos'**
  String get noProducts;

  /// Mensaje instrucciones para crear primer producto
  ///
  /// In es, this message translates to:
  /// **'Crea tu primer producto usando el botón +'**
  String get createFirstProduct;

  /// Botón para crear nuevo producto
  ///
  /// In es, this message translates to:
  /// **'Nuevo Producto'**
  String get newProduct;

  /// Título del diálogo para crear producto
  ///
  /// In es, this message translates to:
  /// **'Crear Producto'**
  String get createProduct;

  /// Título del diálogo para editar producto
  ///
  /// In es, this message translates to:
  /// **'Editar Producto'**
  String get editProduct;

  /// Label para nombre en español
  ///
  /// In es, this message translates to:
  /// **'Nombre (ES) *'**
  String get nameEs;

  /// Label para nombre en inglés
  ///
  /// In es, this message translates to:
  /// **'Nombre (EN) *'**
  String get nameEn;

  /// Label para descripción en español
  ///
  /// In es, this message translates to:
  /// **'Descripción (ES) *'**
  String get descriptionEs;

  /// Label para descripción en inglés
  ///
  /// In es, this message translates to:
  /// **'Descripción (EN) *'**
  String get descriptionEn;

  /// Label para precio
  ///
  /// In es, this message translates to:
  /// **'Precio *'**
  String get price;

  /// Label checkbox vegano
  ///
  /// In es, this message translates to:
  /// **'Es vegano'**
  String get isVegan;

  /// Etiqueta de categoría
  ///
  /// In es, this message translates to:
  /// **'Categoría'**
  String get category;

  /// Mensaje de validación campo requerido
  ///
  /// In es, this message translates to:
  /// **'Requerido'**
  String get required;

  /// Mensaje de validación para número
  ///
  /// In es, this message translates to:
  /// **'Debe ser un número válido >= 0'**
  String get mustBeValidNumber;

  /// Mensaje de error cuando no se selecciona categoría
  ///
  /// In es, this message translates to:
  /// **'Debes seleccionar una categoría'**
  String get mustSelectCategory;

  /// Mensaje de error al seleccionar imágenes
  ///
  /// In es, this message translates to:
  /// **'Error al seleccionar imágenes'**
  String get errorSelectingImages;

  /// Mensaje de error al eliminar imagen
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar imagen'**
  String get errorDeletingImage;

  /// Mensaje de error al subir imagen
  ///
  /// In es, this message translates to:
  /// **'Error al subir imagen'**
  String get errorUploadingImage;

  /// Mensaje de error al actualizar alérgenos
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar alérgenos'**
  String get errorUpdatingAllergens;

  /// Mensaje de error desconocido
  ///
  /// In es, this message translates to:
  /// **'Error desconocido'**
  String get unknownError;

  /// Mensaje de éxito al crear producto
  ///
  /// In es, this message translates to:
  /// **'Producto creado correctamente'**
  String get productCreatedSuccessfully;

  /// Mensaje de éxito al actualizar producto
  ///
  /// In es, this message translates to:
  /// **'Producto actualizado correctamente'**
  String get productUpdatedSuccessfully;

  /// Botón crear
  ///
  /// In es, this message translates to:
  /// **'Crear'**
  String get create;

  /// Botón actualizar
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get update;

  /// Mensaje cuando no hay alérgenos
  ///
  /// In es, this message translates to:
  /// **'No hay alérgenos disponibles'**
  String get noAllergensAvailable;

  /// Título sección alérgenos
  ///
  /// In es, this message translates to:
  /// **'Alérgenos (opcional)'**
  String get allergensOptional;

  /// Instrucciones para seleccionar alérgenos
  ///
  /// In es, this message translates to:
  /// **'Selecciona los alérgenos que aplican a este producto:'**
  String get selectAllergens;

  /// Título sección imágenes
  ///
  /// In es, this message translates to:
  /// **'Imágenes (opcional)'**
  String get imagesOptional;

  /// Título para imágenes existentes
  ///
  /// In es, this message translates to:
  /// **'Imágenes existentes:'**
  String get existingImages;

  /// Botón para añadir imágenes
  ///
  /// In es, this message translates to:
  /// **'Añadir imágenes'**
  String get addImages;

  /// Texto explicativo imágenes a subir
  ///
  /// In es, this message translates to:
  /// **'Imágenes seleccionadas (se subirán al guardar):'**
  String get selectedImagesWillBeUploaded;

  /// Botón reactivar producto
  ///
  /// In es, this message translates to:
  /// **'Reactivar'**
  String get reactivate;

  /// Mensaje de éxito al reactivar producto
  ///
  /// In es, this message translates to:
  /// **'Producto reactivado'**
  String get productReactivated;

  /// Mensaje de error al reactivar producto
  ///
  /// In es, this message translates to:
  /// **'Error al reactivar el producto'**
  String get errorReactivatingProduct;

  /// Botón desactivar producto
  ///
  /// In es, this message translates to:
  /// **'Desactivar'**
  String get deactivate;

  /// Título diálogo confirmación desactivación
  ///
  /// In es, this message translates to:
  /// **'Confirmar desactivación'**
  String get confirmDeactivation;

  /// Mensaje diálogo confirmación desactivación
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas desactivar el producto \'{productName}\'?'**
  String confirmDeactivationMessage(String productName);

  /// Mensaje de éxito al desactivar producto
  ///
  /// In es, this message translates to:
  /// **'Producto desactivado'**
  String get productDeactivated;

  /// Mensaje de error al desactivar producto
  ///
  /// In es, this message translates to:
  /// **'Error al desactivar el producto'**
  String get errorDeactivatingProduct;

  /// Label vegano
  ///
  /// In es, this message translates to:
  /// **'Vegano'**
  String get vegan;

  /// Estado activo
  ///
  /// In es, this message translates to:
  /// **'Activo'**
  String get active;

  /// Estado inactivo
  ///
  /// In es, this message translates to:
  /// **'Inactivo'**
  String get inactive;

  /// Texto cuando no hay categoría asignada
  ///
  /// In es, this message translates to:
  /// **'Sin categoría'**
  String get noCategory;

  /// Saludo
  ///
  /// In es, this message translates to:
  /// **'Hola'**
  String get hello;

  /// Panel de control del administrador
  ///
  /// In es, this message translates to:
  /// **'Panel de Control'**
  String get dashboard;

  /// Navegación productos
  ///
  /// In es, this message translates to:
  /// **'Productos'**
  String get products;

  /// Navegación facturación
  ///
  /// In es, this message translates to:
  /// **'Facturación'**
  String get billing;

  /// Navegación perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Navegación inicio
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// Navegación menú
  ///
  /// In es, this message translates to:
  /// **'Menú'**
  String get menu;

  /// Navegación pedidos
  ///
  /// In es, this message translates to:
  /// **'Pedidos'**
  String get orders;

  /// Mensaje de validación campo requerido genérico
  ///
  /// In es, this message translates to:
  /// **'{field} es obligatorio'**
  String fieldRequired(String field);

  /// Mensaje validación email requerido
  ///
  /// In es, this message translates to:
  /// **'El email es obligatorio'**
  String get emailRequired;

  /// Mensaje validación email inválido
  ///
  /// In es, this message translates to:
  /// **'Email no válido'**
  String get invalidEmail;

  /// Mensaje validación contraseña requerida
  ///
  /// In es, this message translates to:
  /// **'La contraseña es obligatoria'**
  String get passwordRequired;

  /// Mensaje validación longitud mínima contraseña
  ///
  /// In es, this message translates to:
  /// **'Mínimo 8 caracteres'**
  String get passwordMinLength;

  /// Mensaje validación mayúscula en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una mayúscula'**
  String get passwordUppercase;

  /// Mensaje validación minúscula en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos una minúscula'**
  String get passwordLowercase;

  /// Mensaje validación número en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos un número'**
  String get passwordNumber;

  /// Mensaje validación carácter especial en contraseña
  ///
  /// In es, this message translates to:
  /// **'Debe contener al menos un carácter especial'**
  String get passwordSpecialChar;

  /// Mensaje validación confirmar contraseña requerido
  ///
  /// In es, this message translates to:
  /// **'Confirma tu contraseña'**
  String get confirmPasswordRequired;

  /// Mensaje validación contraseñas no coinciden
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// Mensaje validación nombre requerido
  ///
  /// In es, this message translates to:
  /// **'El nombre es obligatorio'**
  String get nameRequired;

  /// Mensaje validación nombre muy corto
  ///
  /// In es, this message translates to:
  /// **'Nombre demasiado corto'**
  String get nameTooShort;

  /// Título página perfil
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get myProfile;

  /// Rol administrador
  ///
  /// In es, this message translates to:
  /// **'Administrador'**
  String get administrator;

  /// Rol usuario
  ///
  /// In es, this message translates to:
  /// **'Usuario'**
  String get user;

  /// Título sección información personal
  ///
  /// In es, this message translates to:
  /// **'Información Personal'**
  String get personalInfo;

  /// Label teléfono
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// Texto cuando un dato no está proporcionado
  ///
  /// In es, this message translates to:
  /// **'No proporcionado'**
  String get notProvided;

  /// Label dirección
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// Label ciudad
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get city;

  /// Label código postal
  ///
  /// In es, this message translates to:
  /// **'Código Postal'**
  String get postalCode;

  /// Label país
  ///
  /// In es, this message translates to:
  /// **'País'**
  String get country;

  /// Botón editar perfil
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// Botón cambiar contraseña
  ///
  /// In es, this message translates to:
  /// **'Cambiar Contraseña'**
  String get changePassword;

  /// Botón cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logout;

  /// Mensaje error al cargar perfil
  ///
  /// In es, this message translates to:
  /// **'Error al cargar perfil'**
  String get errorLoadingProfile;

  /// Título diálogo confirmación cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar Sesión'**
  String get logoutConfirmTitle;

  /// Mensaje diálogo confirmación cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'¿Estás seguro de que deseas cerrar sesión?'**
  String get logoutConfirmMessage;

  /// Mensaje error al cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Error al cerrar sesión'**
  String get errorLoggingOut;

  /// Label URL avatar
  ///
  /// In es, this message translates to:
  /// **'URL del Avatar'**
  String get avatarUrl;

  /// Label dirección línea 1
  ///
  /// In es, this message translates to:
  /// **'Dirección (Línea 1)'**
  String get addressLine1;

  /// Label dirección línea 2
  ///
  /// In es, this message translates to:
  /// **'Dirección (Línea 2)'**
  String get addressLine2;

  /// Label código de país
  ///
  /// In es, this message translates to:
  /// **'Código de País'**
  String get countryCode;

  /// Botón guardar cambios
  ///
  /// In es, this message translates to:
  /// **'Guardar Cambios'**
  String get saveChanges;

  /// Mensaje éxito actualizar perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado correctamente'**
  String get profileUpdatedSuccessfully;

  /// Mensaje error actualizar perfil
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar perfil'**
  String get errorUpdatingProfile;

  /// Label contraseña actual
  ///
  /// In es, this message translates to:
  /// **'Contraseña Actual'**
  String get currentPassword;

  /// Label nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Nueva Contraseña'**
  String get newPassword;

  /// Label confirmar nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirmar Nueva Contraseña'**
  String get confirmNewPassword;

  /// Mensaje requisitos de contraseña
  ///
  /// In es, this message translates to:
  /// **'La contraseña debe tener al menos 8 caracteres, incluir mayúsculas, minúsculas, números y caracteres especiales.'**
  String get passwordRequirements;

  /// Mensaje éxito cambiar contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña actualizada correctamente'**
  String get passwordUpdatedSuccessfully;

  /// Mensaje error cambiar contraseña
  ///
  /// In es, this message translates to:
  /// **'Error al cambiar contraseña'**
  String get errorChangingPassword;

  /// Error usuario no encontrado
  ///
  /// In es, this message translates to:
  /// **'No existe un usuario con ese email'**
  String get errorUserNotFound;

  /// Error contraseña incorrecta
  ///
  /// In es, this message translates to:
  /// **'La contraseña introducida es incorrecta'**
  String get errorInvalidPassword;

  /// Error email ya existe
  ///
  /// In es, this message translates to:
  /// **'Este email ya está registrado'**
  String get errorEmailAlreadyInUse;

  /// Error contraseña débil
  ///
  /// In es, this message translates to:
  /// **'La contraseña no cumple los requisitos de seguridad'**
  String get errorWeakPassword;

  /// Error no autenticado
  ///
  /// In es, this message translates to:
  /// **'No estás autenticado. Por favor, inicia sesión'**
  String get errorUnauthorized;

  /// Error sin permisos
  ///
  /// In es, this message translates to:
  /// **'No tienes permisos para realizar esta acción'**
  String get errorForbidden;

  /// Error token caducado
  ///
  /// In es, this message translates to:
  /// **'Tu sesión ha caducado. Por favor, inicia sesión de nuevo'**
  String get errorTokenExpired;

  /// Error token inválido
  ///
  /// In es, this message translates to:
  /// **'Token inválido. Por favor, inicia sesión de nuevo'**
  String get errorInvalidToken;

  /// Error token no proporcionado
  ///
  /// In es, this message translates to:
  /// **'No se proporcionó token de autenticación'**
  String get errorTokenNotProvided;

  /// Error recurso no encontrado
  ///
  /// In es, this message translates to:
  /// **'El recurso solicitado no se encontró'**
  String get errorNotFound;

  /// Error solicitud incorrecta
  ///
  /// In es, this message translates to:
  /// **'La solicitud contiene datos inválidos'**
  String get errorBadRequest;

  /// Error interno servidor
  ///
  /// In es, this message translates to:
  /// **'Error interno del servidor. Inténtalo más tarde'**
  String get errorInternalServer;

  /// Error de red/conexión
  ///
  /// In es, this message translates to:
  /// **'Error de conexión. Verifica tu internet'**
  String get errorNetwork;

  /// Error genérico
  ///
  /// In es, this message translates to:
  /// **'Ha ocurrido un error. Inténtalo de nuevo'**
  String get errorGeneric;

  /// Título login
  ///
  /// In es, this message translates to:
  /// **'Inicia sesión'**
  String get loginTitle;

  /// Título registro
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get registerTitle;

  /// Subtítulo auth
  ///
  /// In es, this message translates to:
  /// **'Comidas zero waste, recogida sin esperas.'**
  String get authSubtitle;

  /// Botón login
  ///
  /// In es, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// Botón registro
  ///
  /// In es, this message translates to:
  /// **'Registro'**
  String get registerButton;

  /// Rol cliente
  ///
  /// In es, this message translates to:
  /// **'Cliente'**
  String get clientRole;

  /// Rol admin
  ///
  /// In es, this message translates to:
  /// **'Admin'**
  String get adminRole;

  /// Estado entrando
  ///
  /// In es, this message translates to:
  /// **'Entrando...'**
  String get loggingIn;

  /// Botón entrar
  ///
  /// In es, this message translates to:
  /// **'Entrar'**
  String get login;

  /// Estado creando cuenta
  ///
  /// In es, this message translates to:
  /// **'Creando cuenta...'**
  String get creatingAccount;

  /// Botón crear cuenta
  ///
  /// In es, this message translates to:
  /// **'Crear cuenta'**
  String get createAccount;

  /// Label nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Label contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// Texto aceptar términos
  ///
  /// In es, this message translates to:
  /// **'Al continuar aceptas la recogida rápida y el sistema de puntos.'**
  String get authAcceptTerms;

  /// Mensaje éxito registro
  ///
  /// In es, this message translates to:
  /// **'¡Te has registrado con éxito {name} con el email {email}!'**
  String registerSuccessMessage(String name, String email);

  /// Error login fallido
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar sesión'**
  String get errorLoginFailed;

  /// Error registro fallido
  ///
  /// In es, this message translates to:
  /// **'Error en el registro'**
  String get errorRegisterFailed;

  /// Limpiar filtro activo
  ///
  /// In es, this message translates to:
  /// **'Limpiar filtro'**
  String get clearFilter;

  /// No hay productos en la categoría seleccionada
  ///
  /// In es, this message translates to:
  /// **'No hay productos en esta categoría'**
  String get noProductsInCategory;

  /// Sugerencia para cambiar de categoría
  ///
  /// In es, this message translates to:
  /// **'Prueba con otra categoría'**
  String get tryAnotherCategory;

  /// Cargando lista de categorías
  ///
  /// In es, this message translates to:
  /// **'Cargando categorías...'**
  String get loadingCategories;

  /// Placeholder para buscar productos
  ///
  /// In es, this message translates to:
  /// **'Buscar productos...'**
  String get searchProducts;

  /// Resumen general
  ///
  /// In es, this message translates to:
  /// **'Resumen General'**
  String get overview;

  /// Pedidos totales
  ///
  /// In es, this message translates to:
  /// **'Pedidos Totales'**
  String get totalOrders;

  /// Ingresos totales
  ///
  /// In es, this message translates to:
  /// **'Ingresos'**
  String get revenue;

  /// Total de usuarios
  ///
  /// In es, this message translates to:
  /// **'Usuarios'**
  String get users;

  /// Pedidos recientes
  ///
  /// In es, this message translates to:
  /// **'Pedidos Recientes'**
  String get recentOrders;

  /// No hay pedidos recientes
  ///
  /// In es, this message translates to:
  /// **'No hay pedidos recientes'**
  String get noRecentOrders;

  /// Mensaje de pedidos vacíos
  ///
  /// In es, this message translates to:
  /// **'Los pedidos aparecerán aquí cuando los clientes hagan compras'**
  String get ordersWillAppearHere;

  /// Productos más vendidos
  ///
  /// In es, this message translates to:
  /// **'Productos Más Vendidos'**
  String get topProducts;

  /// No hay datos de ventas
  ///
  /// In es, this message translates to:
  /// **'No hay datos de ventas'**
  String get noSalesData;

  /// Mensaje de datos de ventas vacíos
  ///
  /// In es, this message translates to:
  /// **'Los datos de ventas aparecerán aquí cuando se realicen compras'**
  String get salesDataWillAppearHere;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
