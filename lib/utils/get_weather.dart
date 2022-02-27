/*
 * @Date         : 2022-02-27 21:09:21
 * @LastEditTime : 2022-02-27 21:17:52
 * @Description  : file content
 * @FilePath     : /ajusTV/lib/utils/get_weather.dart
 */

import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:package_info/package_info.dart';
import 'package:update_app/bean/download_process.dart';
import 'package:update_app/update_app.dart';

class WeatherUtils {
  static var data;

  static Future<dynamic> fetchWeatheData() async {
    if (data != null) {
      return data;
    }
    var url = Uri.parse(
        'https://v0.yiketianqi.com/api?unescape=1&version=v61&appid=93864347&appsecret=sdgX6LXR');
    var response = await http.get(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    data = jsonResponse;

    print(data);

    return data;
  }
}
