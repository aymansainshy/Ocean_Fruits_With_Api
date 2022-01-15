
class Urls {

  static String mainRouteUrl() => "main-route";
  
  static String searchUrl(String langCode , String query) =>"/app/products-search/$langCode/$query";
  static String fetchRelatedProducts(String productId) => "/app/get-related-products/$productId";
  static String addAndRemoveFavoriteUrl(String productId) => "/app/add-to-favourites/$productId";
  static String addAndRemoveToCartUrl(String productId) => "/app/add-to-cart/$productId";
  static String fetchOrderDetails(String orderId) => "/app/get-order-details/$orderId";
  static String fetcheredProductUrl() => "/app/get-featured-products";
  static String updatePasswordUrl() => "/user-auth/update-password";
  static String updateUserInfo() => "/user-auth/update-user-infos";
  static String favProductsUrl() => "/app/get-favourite-products";
  static String deliveryTimeUrl() => "/app/get-delivery-times";
  static String getOffersUrl() => "/app/get-offered-products";
  static String fetchCategoriesUrl() => "/app/get-categories";
  static String fetchCartUrl() => "/app/get-cart-products";
  static String fetchUserInfo() => "/user-auth/profile";
  static String registerUrl() => "/user-auth/register";
  static String createOrderUrle() => "/app/add-order";
  static String fetchOrdersUrl() => "/app/get-orders";
  static String logInUrl() => "/user-auth/login";
  static String slidUrl() => "/app/get-slides";


  static final Urls _instance = Urls._internal();

  factory Urls() {
    return _instance;
  }

  Urls._internal();
}
