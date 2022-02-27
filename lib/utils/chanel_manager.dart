/*
 * @Date         : 2022-02-26 09:58:14
 * @LastEditTime : 2022-02-26 19:02:11
 * @Description  : file content
 * @FilePath     : /ajusTV/lib/utils/chanel_manager.dart
 */

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ChannelManager {
  // Future<List<dynamic>> geturls({channalName: String}) async {
  //   var _urls = await fetchChannelList(channalName: '');
  //   return _urls;
  // }

  static Future<List<dynamic>> fetchChannelList() async {
    var url = Uri.parse('https://gitee.com/ittat/tv/raw/6/channels.json');
    var response = await http.get(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;
    var l = jsonResponse["channels"];

    return l;
  }
}
