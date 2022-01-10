class Preferences {
  static String user = 'user';
  static String language = 'lang';

  ///Singleton factory
  static final Preferences _instance = Preferences._internal();

  factory Preferences() {
    return _instance;
  }

  Preferences._internal();
}