/*
 * @Date         : 2022-02-27 20:56:37
 * @LastEditTime : 2022-02-27 21:57:55
 * @Description  : file content
 * @FilePath     : /ajusTV/lib/ui/weather_page.dart
 */

import 'dart:async';
import 'package:AjusTV/utils/get_weather.dart';
import 'package:AjusTV/widgets/tv_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:wakelock/wakelock.dart';

import 'package:dart_ping/dart_ping.dart';

class WeatherPage extends StatefulWidget {
  // final String url;

  // VideoPage({@required this.url});
  WeatherPage();

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  dynamic data;
  @override
  Future<void> initState() {
    super.initState();
    // this.data = WeatherUtils.fetchWeatheData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: new EdgeInsets.all(0),
            child: Stack(
              children: <Widget>[
                // Text(WeatherUtils.data['tem']),
                ModelViewer(
                  src:
                      'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
                  alt: "A 3D model of an astronaut",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                ),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
