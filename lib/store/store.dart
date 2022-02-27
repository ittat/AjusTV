/*
 * @Date         : 2022-02-27 19:56:00
 * @LastEditTime : 2022-02-27 20:00:20
 * @Description  : file content
 * @FilePath     : /ajusTV/lib/store/store.dart
 */

import 'package:get/get.dart';

class HomeController extends GetxController {
  var isShowList = false;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  @override
  void onClose() {}

  void showList() => isShowList = !isShowList;
}
