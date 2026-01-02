// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EcoBocado';

  @override
  String get homePageTitle => 'Delicious Food';

  @override
  String get homePageTitleAccent => 'Zero Waste';

  @override
  String get homePageSubtitle =>
      'Enjoy the best takeaway food while we take care of our planet. Reusable containers, local ingredients and zero waste.';

  @override
  String get badgeZeroWaste => 'Zero Waste';

  @override
  String get badgeVeganMenus => 'Vegan Menus';

  @override
  String get featureEcoFriendlyFood => 'Eco-Friendly Food';

  @override
  String get featureZeroWaste => 'Zero Waste';

  @override
  String get featureFastPickup => 'Fast Pickup';

  @override
  String get featureNoWaiting => 'No Waiting';

  @override
  String get featuredCard100Sustainable => '100% Sustainable';

  @override
  String get featuredCardTitle => 'Compostable and reusable containers';

  @override
  String get loyaltyBannerTitle =>
      'LOYALTY PROGRAM! 10 purchases = 1 FREE menu';

  @override
  String get loyaltyBannerSubtitle =>
      'Accumulate points and redeem them for delicious rewards.';

  @override
  String get preferences => 'Preferences';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get appNotifications => 'App Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get whatsappNotifications => 'WhatsApp Notifications';

  @override
  String get appearanceSection => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get languageSection => 'Language';

  @override
  String get language => 'Language';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageEnglish => 'English';

  @override
  String get viewCatalog => 'View Catalog';

  @override
  String errorLoadingPreferences(String error) {
    return 'Error loading preferences: $error';
  }

  @override
  String get shopPageTitle => 'Menu';

  @override
  String get filterByCategory => 'Category';

  @override
  String get allCategories => 'All';

  @override
  String get filterByAllergens => 'Allergens';

  @override
  String get noAllergensSelected => 'No filter';

  @override
  String allergensSelectedCount(int count) {
    return '$count selected';
  }

  @override
  String get veganOnly => 'Vegan Only';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortByNewest => 'Newest';

  @override
  String get sortByOldest => 'Oldest';

  @override
  String get sortByNameAsc => 'Name (A-Z)';

  @override
  String get sortByNameDesc => 'Name (Z-A)';

  @override
  String get sortByPriceAsc => 'Price (lowest)';

  @override
  String get sortByPriceDesc => 'Price (highest)';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get applyFilters => 'Apply';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get tryAdjustingFilters => 'Try adjusting the filters';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String get errorLoadingProducts => 'Error loading products';

  @override
  String get retry => 'Retry';

  @override
  String get addToCart => 'Add to cart';

  @override
  String addedToCart(String itemName) {
    return '$itemName added to cart';
  }

  @override
  String get productDetails => 'Product details';

  @override
  String get description => 'Description';

  @override
  String get allergens => 'Allergens';

  @override
  String get contains => 'Contains';

  @override
  String get mayContain => 'May contain';

  @override
  String get noAllergens => 'No allergens declared';

  @override
  String get menuComposition => 'Menu composition';

  @override
  String get mainCourse => 'Main course';

  @override
  String get sideDish => 'Side dish';

  @override
  String get drink => 'Drink';

  @override
  String get dessert => 'Dessert';

  @override
  String get menuBadge => 'Menu';

  @override
  String get myCart => 'My Cart';

  @override
  String get clearCartTooltip => 'Clear cart';

  @override
  String get emptyCartTitle => 'Your cart is empty';

  @override
  String get emptyCartMessage => 'Add products from the menu';

  @override
  String get viewMenu => 'View Menu';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get totalItems => 'Total items';

  @override
  String get total => 'Total';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get orderPendingImplementation =>
      'Order feature pending implementation';

  @override
  String get clearCartDialogTitle => 'Clear cart';

  @override
  String get clearCartDialogMessage =>
      'Are you sure you want to remove all products from the cart?';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get productManagement => 'Product Management';

  @override
  String get reload => 'Reload';

  @override
  String get noProducts => 'No products';

  @override
  String get createFirstProduct =>
      'Create your first product using the + button';

  @override
  String get newProduct => 'New Product';

  @override
  String get createProduct => 'Create Product';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get nameEs => 'Name (ES) *';

  @override
  String get nameEn => 'Name (EN) *';

  @override
  String get descriptionEs => 'Description (ES) *';

  @override
  String get descriptionEn => 'Description (EN) *';

  @override
  String get price => 'Price *';

  @override
  String get isVegan => 'Is vegan';

  @override
  String get category => 'Category';

  @override
  String get required => 'Required';

  @override
  String get mustBeValidNumber => 'Must be a valid number >= 0';

  @override
  String get mustSelectCategory => 'You must select a category';

  @override
  String get errorSelectingImages => 'Error selecting images';

  @override
  String get errorDeletingImage => 'Error deleting image';

  @override
  String get errorUploadingImage => 'Error uploading image';

  @override
  String get errorUpdatingAllergens => 'Error updating allergens';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get productCreatedSuccessfully => 'Product created successfully';

  @override
  String get productUpdatedSuccessfully => 'Product updated successfully';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get noAllergensAvailable => 'No allergens available';

  @override
  String get allergensOptional => 'Allergens (optional)';

  @override
  String get selectAllergens =>
      'Select the allergens that apply to this product:';

  @override
  String get imagesOptional => 'Images (optional)';

  @override
  String get existingImages => 'Existing images:';

  @override
  String get addImages => 'Add images';

  @override
  String get selectedImagesWillBeUploaded =>
      'Selected images (will be uploaded on save):';

  @override
  String get reactivate => 'Reactivate';

  @override
  String get productReactivated => 'Product reactivated';

  @override
  String get errorReactivatingProduct => 'Error reactivating product';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get confirmDeactivation => 'Confirm deactivation';

  @override
  String confirmDeactivationMessage(String productName) {
    return 'Are you sure you want to deactivate the product \'$productName\'?';
  }

  @override
  String get productDeactivated => 'Product deactivated';

  @override
  String get errorDeactivatingProduct => 'Error deactivating product';

  @override
  String get vegan => 'Vegan';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get noCategory => 'No category';

  @override
  String get hello => 'Hello';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get products => 'Products';

  @override
  String get billing => 'Billing';

  @override
  String get profile => 'Profile';

  @override
  String get home => 'Home';

  @override
  String get menu => 'Menu';

  @override
  String get orders => 'Orders';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Minimum 8 characters';

  @override
  String get passwordUppercase => 'Must contain at least one uppercase letter';

  @override
  String get passwordLowercase => 'Must contain at least one lowercase letter';

  @override
  String get passwordNumber => 'Must contain at least one number';

  @override
  String get passwordSpecialChar =>
      'Must contain at least one special character';

  @override
  String get confirmPasswordRequired => 'Confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get nameTooShort => 'Name too short';

  @override
  String get myProfile => 'My Profile';

  @override
  String get administrator => 'Administrator';

  @override
  String get user => 'User';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get phone => 'Phone';

  @override
  String get notProvided => 'Not provided';

  @override
  String get address => 'Address';

  @override
  String get city => 'City';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get country => 'Country';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get errorLoggingOut => 'Error logging out';

  @override
  String get avatarUrl => 'Avatar URL';

  @override
  String get addressLine1 => 'Address (Line 1)';

  @override
  String get addressLine2 => 'Address (Line 2)';

  @override
  String get countryCode => 'Country Code';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordRequirements =>
      'Password must be at least 8 characters long and include uppercase, lowercase, numbers and special characters.';

  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  @override
  String get errorChangingPassword => 'Error changing password';

  @override
  String get errorUserNotFound => 'No user found with that email';

  @override
  String get errorInvalidPassword => 'The password entered is incorrect';

  @override
  String get errorEmailAlreadyInUse => 'This email is already registered';

  @override
  String get errorWeakPassword =>
      'Password does not meet security requirements';

  @override
  String get errorUnauthorized => 'You are not authenticated. Please log in';

  @override
  String get errorForbidden =>
      'You don\'t have permission to perform this action';

  @override
  String get errorTokenExpired =>
      'Your session has expired. Please log in again';

  @override
  String get errorInvalidToken => 'Invalid token. Please log in again';

  @override
  String get errorTokenNotProvided => 'Authentication token not provided';

  @override
  String get errorNotFound => 'The requested resource was not found';

  @override
  String get errorBadRequest => 'The request contains invalid data';

  @override
  String get errorInternalServer => 'Internal server error. Try again later';

  @override
  String get errorNetwork => 'Connection error. Check your internet';

  @override
  String get errorGeneric => 'An error occurred. Please try again';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get authSubtitle => 'Zero waste meals, pickup without waiting.';

  @override
  String get loginButton => 'Login';

  @override
  String get registerButton => 'Register';

  @override
  String get clientRole => 'Client';

  @override
  String get adminRole => 'Admin';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get login => 'Sign in';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get createAccount => 'Create account';

  @override
  String get name => 'Name';

  @override
  String get password => 'Password';

  @override
  String get authAcceptTerms =>
      'By continuing you accept fast pickup and the loyalty points system.';

  @override
  String registerSuccessMessage(String name, String email) {
    return 'Successfully registered $name with email $email!';
  }

  @override
  String get errorLoginFailed => 'Login failed';

  @override
  String get errorRegisterFailed => 'Registration error';

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get noProductsInCategory => 'No products in this category';

  @override
  String get tryAnotherCategory => 'Try another category';

  @override
  String get loadingCategories => 'Loading categories...';

  @override
  String get searchProducts => 'Search products...';

  @override
  String get overview => 'Overview';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get revenue => 'Revenue';

  @override
  String get users => 'Users';

  @override
  String get recentOrders => 'Recent Orders';

  @override
  String get noRecentOrders => 'No recent orders';

  @override
  String get ordersWillAppearHere =>
      'Orders will appear here when customers make purchases';

  @override
  String get topProducts => 'Top Products';

  @override
  String get noSalesData => 'No sales data';

  @override
  String get salesDataWillAppearHere =>
      'Sales data will appear here when purchases are made';
}
