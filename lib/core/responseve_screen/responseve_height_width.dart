import 'package:zytronic_task/core/responseve_screen/screen_size.dart';

extension HeightWidthResponsive on int {
  double get heightResponsive {
    final screenHeight = ScreenSize.height?? 812;
    return (this / screenHeight) * screenHeight;
  }

  double get widthResponsive {
    final screenWidth = ScreenSize.width?? 375;
    return (this / screenWidth) * screenWidth;
  }

}
