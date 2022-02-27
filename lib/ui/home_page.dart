import 'dart:async';

import 'package:AjusTV/ui/video_page.dart';
import 'package:AjusTV/ui/weather_page.dart';
import 'package:AjusTV/utils/app_update.dart';
import 'package:AjusTV/utils/chanel_manager.dart';
import 'package:AjusTV/widgets/tv_widget.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info/package_info.dart';
import 'package:update_app/bean/download_process.dart';

import 'package:update_app/update_app.dart';

import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  // 当前子项索引
  int currentIndex = 0;
  // 子项集
  List<Widget> childrenPage;

  List<Widget> channelList;

  bool notShowList = true;

  // 控制器
  PageController _controller = PageController(initialPage: 0, keepPage: false);

  Future<List<Widget>> _makePageWeight() async {
    List<dynamic> list = await ChannelManager.fetchChannelList();
    print(list);
    setState(() {});
    this.childrenPage = [];
    this.channelList = [];
    this.childrenPage.add(WeatherPage());
    this.channelList.add(Text('Weather'));

    this.channelList.addAll(list
        .asMap()
        .map((key, value) => MapEntry(
            key,
            TVWidget(
              child: Padding(
                  padding: new EdgeInsets.all(20),
                  child: Container(
                    // color: currentIndex == key ? Colors.blue[200] : null,
                    child: GestureDetector(
                      child: Image.network(value['logo'],
                          width: MediaQuery.of(context).size.width / 3),
                      onTap: () {
                        setState(() {});
                        currentIndex = key;
                        _controller.jumpToPage(key);
                      },
                    ),
                  )),
              onclick: () {
                setState(() {});
                currentIndex = key;
                _controller.jumpToPage(key);
              },
            )))
        .values
        .toList());

    this
        .childrenPage
        .addAll(list.map((e) => VideoPage(url: e['url'][0])).toList());

    print(this.channelList.length);
  }

  _ckeckVersion() async {
    var url = await AppUpdate.checkAppUpdate();
    if (url != null) {
      AppUpdate.download(url: url);
    }
  }

  //倒计时处理
  static const timeout = const Duration(seconds: 5);
  Timer timer;

  startTimeout(Function fn) {
    timer = Timer(timeout, fn);
    return timer;
  }

  @override
  Future<void> initState() {
    _makePageWeight();
    _ckeckVersion();
    // startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Container(
      color: Colors.black87,
      child: Stack(
        children: <Widget>[
          PageView.builder(
            itemCount: childrenPage != null ? childrenPage.length : 0,
            controller: _controller,
            onPageChanged: (value) {
              print("onPageChanged");
              setState(() {
                currentIndex = value;
              });
            },
            itemBuilder: (context, index) {
              return childrenPage[index];
            },
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Offstage(
                offstage: notShowList,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: notShowList ? null : Colors.black54,
                    // border: Border.all(color: Colors.white),
                  ),
                  child: PageView.builder(
                    itemCount: channelList != null ? channelList.length : 0,
                    // controller: _controller,
                    onPageChanged: (value) {
                      setState(() {});
                      currentIndex = value;
                      _controller.jumpToPage(value);
                    },
                    itemBuilder: (context, index) {
                      return channelList[index];
                    },
                  ),
                )),
          ),
          Positioned(
              top: 0,
              left: 0,
              child: Row(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.white,
                            ),
                            // child: Image.asset("assets/logo.png"),
                          ),
                          onTap: () {
                            FocusScope.of(context)
                                .focusInDirection(TraversalDirection.left);
                          }),
                      GestureDetector(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.white,
                            ),
                            // child: Image.asset("assets/logo.png"),
                          ),
                          onTap: () {
                            FocusScope.of(context)
                                .focusInDirection(TraversalDirection.right);
                          }),
                      GestureDetector(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: ShapeDecoration(
                              shape: CircleBorder(),
                              color: Colors.white,
                            ),
                            // child: Image.asset("assets/logo.png"),
                          ),
                          onTap: () {
                            setState(() {
                              notShowList = !notShowList;
                            });
                          }),
                    ],
                  ),
                ],
              )),
        ],
      ),
    ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
