/*
 * @Date         : 2022-02-26 09:50:17
 * @LastEditTime : 2022-02-26 09:57:21
 * @Description  : file content
 * @FilePath     : /ajusTV/lib/utils/app_update.dart
 */

import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:package_info/package_info.dart';
import 'package:update_app/bean/download_process.dart';
import 'package:update_app/update_app.dart';

class AppUpdate {
  //下载进度
  double downloadProcess = 0;

  //下载状态
  String downloadStatus = "";

  void download({url: String}) async {
    var downloadId = await UpdateApp.updateApp(
      url: url,
      // appleId: "375380948"
    );

    //本地已有一样的apk, 下载成功
    if (downloadId == 0) {
      downloadProcess = 1;
      downloadStatus = ProcessState.STATUS_SUCCESSFUL.toString();
      return;
    }

    //出现了错误, 下载失败
    if (downloadId == -1) {
      downloadProcess = 1;
      downloadStatus = ProcessState.STATUS_FAILED.toString();
      return;
    }

    //正在下载文件
    var timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      var process = await UpdateApp.downloadProcess(downloadId: downloadId);
      //更新界面状态
      downloadProcess = process.current / process.count;
      downloadStatus = process.status.toString();

      if (process.status == ProcessState.STATUS_SUCCESSFUL ||
          process.status == ProcessState.STATUS_FAILED) {
        //如果已经下载成功, 取消计时
        timer.cancel();
      }
    });
  }

  Future<dynamic> checkAppUpdate() async {
    var url = Uri.parse(
        'https://github.com/ittat-store/data/releases/download/0.1/update.json');
    var response = await http.get(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version);

    if (packageInfo.version != jsonResponse['version']) {
      return jsonResponse['url'];
    } else {
      return null;
    }
  }
}
