class AppImage {
  final String path;
  final double? width;
  final double? height;

  const AppImage({
    required this.path,
    required this.width,
    required this.height,
  });
}

class LogoApp {
  static const AppImage logo = AppImage(
    path: 'assets/images/logo.png',
    width: 120,
    height: 120,
  );

  static const AppImage logo1 = AppImage(
    path: 'assets/images/logo1.png',
    width: 1535,
    height: 1535,
  );

  static const AppImage logoBobo = AppImage(
    path: 'assets/images/bobo.png',
    width: 400,
    height: 400,
  );

  static const AppImage boarding1 = AppImage(
    path: 'assets/images/boarding1.png',
    width: 400,
    height: 300,
  );

  static const AppImage boarding2 = AppImage(
    path: 'assets/images/boarding2.png',
    width: 400,
    height: 300,
  );

  static const AppImage boarding3 = AppImage(
    path: 'assets/images/boarding3.png',
    width: 400,
    height: 300,
  );
}
