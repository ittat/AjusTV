import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:AjusTV/ui/video_page.dart';
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
  List<Widget> childrenPage = [];

  List<Widget> childrenList;

  List<dynamic> channelList;

  bool flag = true;

  // 控制器
  PageController _controller = PageController(initialPage: 0, keepPage: false);

  Future<List<Widget>> _makePageWeight() async {
    List<dynamic> list = await ChannelManager.fetchChannelList();
    print(list);
    this.channelList = list;
    this.flag = !this.flag;
    this.childrenPage = list.map((e) => VideoPage(url: e['url'][0])).toList();
  }

  @override
  Future<void> initState() {
    super.initState();
    _makePageWeight();
    // this._controller.jumpToPage(1);
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
            // itemCount: channelList != null ? channelList.length : 0,
            itemBuilder: (context, index) {
              return childrenPage[index];
            },
          ),

          //  PageView.builder(
          //   itemCount: childrenPage.length,
          //   controller: _controller,
          //   itemBuilder: (BuildContext context, int itemIndex) {
          //     return Padding(
          //       // padding: const EdgeInsets.symmetric(horizontal: 4.0),
          //       child: VideoPage(url: this.channelList[itemIndex]['url']),
          //     );
          //   },
          // ),

          // PageView(
          //   // 设置控制器
          //   controller: _controller,
          //   // 设置子项集
          //   children: this.childrenPage,
          //   // 添加页面滑动改变后，去改变索引变量刷新页面来更新底部导航
          //   onPageChanged: (value) {
          //     currentIndex = value;
          //   },
          // ),

          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
                width: MediaQuery.of(context).size.width - 5,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                  // color: Colors.teal,
                  border: Border.all(color: Colors.white),
                ),
                child: new ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    TVWidget(
                      child: Padding(
                        padding: new EdgeInsets.all(2),
                        child: GestureDetector(
                          child: Image.network(
                              "http://epg.51zmt.top:8000/tb1/CCTV/CCTV13.png"),
                          onTap: () => {
                            currentIndex = 0,
                            this._controller.jumpToPage(0)
                          },
                        ),
                      ),
                      onclick: () => {},
                    ),
                    TVWidget(
                      child: Padding(
                        padding: new EdgeInsets.all(2),
                        child: GestureDetector(
                          child: Image.network(
                              "http://epg.51zmt.top:8000/tb1/CCTV/CCTV4.png"),
                          onTap: () => {
                            currentIndex = 1,
                            this._controller.jumpToPage(1)
                          },
                        ),
                      ),
                      onclick: () => {},
                    ),
                    TVWidget(
                      child: Padding(
                        padding: new EdgeInsets.all(2),
                        child: GestureDetector(
                          child: Image.network(
                              "http://www.tvyan.com/uploads/dianshi/gdzjpd.jpg"),
                          onTap: () =>
                              {currentIndex = 2, _controller.jumpToPage(2)},
                        ),
                      ),
                      onclick: () => {},
                    ),
                  ],
                )),
          ),
        ],
      ),
    ));
  }

  List<VideoPage> _Pages = [
    VideoPage(
        url:
            'http://39.135.138.60:18890/PLTV/88888910/224/3221225638/index.m3u8'),
    VideoPage(
        url: 'http://117.148.179.182/PLTV/88888888/224/3221231726/index.m3u8'),
    VideoPage(
        url:
            'http://astream.apk1088.com:18888/channel.php?id=gdzhujiang_1500&/PLTV/hls.smil.m3u8'),
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
