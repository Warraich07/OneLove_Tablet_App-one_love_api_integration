import 'package:get/get.dart';

extension PercentSized on double {
  double get w => (Get.width * (this / 100));
  double get h => (Get.height * (this / 100));
}