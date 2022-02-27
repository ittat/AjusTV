import 'dart:async';
import 'package:AjusTV/widgets/tv_widget.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wakelock/wakelock.dart';

import 'package:dart_ping/dart_ping.dart';

List<String> channelList = ["CCTV4", "CCTV13", "zhujian", "CCTV5", "CCTV5+"];

class VideoPage extends StatefulWidget {
  final String url;

  VideoPage({@required this.url});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final FijkPlayer player = FijkPlayer();

  int _curChannal = 0;

  int _outTimeCount = 0;

  List<int> banIndex = [];

  int curIndex = 0;

  StreamSubscription<bool> _onBufferStateUpdate;

  List<dynamic> _urls = [];

  String _url;

  // StreamSubscription<Duration> _currentPosSubs;

  _VideoPageState();

  @override
  Future<void> initState() {
    super.initState();
    // geturls(channalName: widget.channalName).then((urls) => {_startVideo()});
    Wakelock.enable();
    player.setDataSource(widget.url, autoPlay: true);
    // await player.setOption(FijkOption., "start-on-prepared", 1);
    player.addListener(_videoSrceenListener);
    _onBufferStateUpdate = player.onBufferStateUpdate.listen(_videoLoading);
    // player.onBufferPercentUpdate.listen(_videoBufferPercent);
  }

  _startVideo() async {
    // if (player.state.name == 'started') {
    //   await player.stop();
    //   await player.reset();
    // }

    print("###################!!!!!!!!!!${_urls[curIndex]}");
    print("###################!!!!!!!!!!${_urls[curIndex]}");
    print("###################!!!!!!!!!!${_urls[curIndex]}");
    print("###################!!!!!!!!!!${_urls[curIndex]}");
    // player.setDataSource(_urls[curIndex], autoPlay: true);
  }

  void _videoSrceenListener() {
    if (player.state.name == "error") {
      _urls.removeAt(curIndex);
      _outTimeCount = 2;
      _videoLoading(true);
    } else if (player.state.name == "completed") {
      Navigator.pop(context);
    }

    print("###################!!!!!!!!!!${player.state.name}");
  }

  _videoLoading(isloading) async {
    if (isloading == true) {
      Fluttertoast.showToast(
          msg: "卡了${_outTimeCount}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    _outTimeCount = _outTimeCount + 1;
    if (_outTimeCount > 2) {
      _outTimeCount = 0;

      if (!banIndex.contains(curIndex)) {
        banIndex.add(curIndex);
      }

      while (banIndex.contains(curIndex)) {
        curIndex = curIndex + 1;
        if (curIndex == _urls.length) {
          curIndex = 0;
        }
        if (banIndex.length >= _urls.length) {
          Fluttertoast.showToast(
              msg: "全部通道质量低！！！",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);

          banIndex = [];
          curIndex = 0;
        }
      }

      print("#########播放通道##########!!!!!!!!!!${curIndex}");
      print("#########播放通道##########!!!!!!!!!!${banIndex}");
      print("#########播放通道##########!!!!!!!!!!${_urls}");

      await _startVideo();
    }
  }

  // void _videoBufferPercent(isloading) {
  //   Fluttertoast.showToast(
  //       msg: isloading.toString(),
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("Fijkplayer Example")),
        body: Padding(
            padding: new EdgeInsets.all(0),
            child: Stack(
              children: <Widget>[
                FijkView(player: player),
                // Positioned(
                //   left: 0,
                //   bottom: 0,
                //   child: Container(
                //       width: MediaQuery.of(context).size.width - 5,
                //       height: MediaQuery.of(context).size.height / 2,
                //       decoration: BoxDecoration(
                //         // color: Colors.teal,
                //         border: Border.all(color: Colors.white),
                //       ),
                //       child: new ListView(
                //         scrollDirection: Axis.horizontal,
                //         children: [
                //           TVWidget(
                //             child: Padding(
                //               padding: new EdgeInsets.all(2),
                //               child: Image.network(
                //                   "https://cn.bing.com/th?id=OPN.RTNews_eC2BasO3llFWfrOR82shuw&w=186&h=88&c=7&rs=2&qlt=80&pid=PopNow"),
                //             ),
                //             onclick: () => {
                //               // geturls(channalName: channelList[_curChannal])
                //               //     .then((urls) => {
                //               //           print(
                //               //               "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"),
                //               //           _startVideo(),
                //               //           _curChannal = _curChannal + 1
                //               //         })
                //             },
                //           ),
                //         ],
                //       )),
                // ),
              ],
            )));
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    _onBufferStateUpdate.cancel();
    // _currentPosSubs.cancel();
    player.removeListener(_videoSrceenListener);
    player.release();
  }
}
