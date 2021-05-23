import 'package:flutter/material.dart';
import 'package:test_responsive_app/src/utils.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';
import 'package:test_responsive_app/generated/images.asset.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
      theme: ThemeData(brightness: Brightness.dark),
    );
  }
}

typedef Widget ResponsiveBuilder(bool isWide, double width);

class ResponsiveWidget extends StatelessWidget {
  final ResponsiveBuilder builder;

  const ResponsiveWidget({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, box) => OrientationBuilder(
          builder: (_, orientation) =>
              builder(orientation == Orientation.landscape, box.maxWidth)),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> videos = [
    "yLNczKeqXyo",
    "zSbsIiluixw",
    "bvq7wbn4VAA",
    "HAstl_NkXl0",
    "MIepaf7ks40",
    "m0d_pbgeeG8",
    "1uZFaAncYu8",
    "A3ltMaM6noM",
    "0LqTlDXtzg4",
    "4Jd676L8ElE",
    "G46cxw9mNFs",
    "2eTY2QrNrAQ",
    "IdrCyS7EF8M"
  ];

  YoutubePlayerController ytController;

  @override
  void initState() {
    super.initState();
    ytController = YoutubePlayerController(
        initialVideoId: videos[0],
        params: YoutubePlayerParams(autoPlay: false));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(builder: (isWide, width) {
      return Scaffold(
        drawer: !isWide || width < 1200 ? Drawer(child: LeftPanel()) : null,
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                Images.ytLogoRgbDark,
                width: 100,
              ),
            ],
          ),
        ),
        body: isWide
            ? width >= 1200
                ? _extraWide()
                : _wideLayout()
            : _smallLayout(),
      );
    });
  }

  _extraWide() => Row(
        children: [
          SizedBox(
            width: 200,
            child: LeftPanel(),
          ),
          Expanded(child: _wideLayout())
        ],
      );

  _wideLayout() => Row(
        children: [
          Expanded(child: Player(ytController: ytController)),
          SizedBox(
              width: 300,
              child: Playlist(
                onVideoTap: (videoId) {
                  ytController.load(videoId);
                  ytController.stop();
                },
                videos: videos,
              ))
        ],
      );

  _smallLayout() => Column(
        children: [
          Player(ytController: ytController),
          Expanded(
              child: Playlist(
            onVideoTap: (videoId) {
              ytController.load(videoId);
              ytController.stop();
            },
            videos: videos,
          ))
        ],
      );
}

class LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              Images.speaker3,
              fit: BoxFit.cover,
              width: 100,
              height: 100,
            ),
          ),
          SizedBox(height: 20),
          Text("Ishaq Hassan", style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 10),
          Text("ishaquehassan@gmail.com",
              style: Theme.of(context).textTheme.subtitle2),
        ],
      ),
    );
  }
}

class Player extends StatelessWidget {
  final YoutubePlayerController ytController;

  const Player({Key key, this.ytController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ResponsiveWidget(
          builder: (isWide, _) => isWide
              ? ListView(
                  children: views(context),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: views(context))),
    );
  }

  List<Widget> views(BuildContext context) => [
        YoutubePlayerIFrame(
          controller: ytController,
          aspectRatio: 16 / 9,
        ),
        SizedBox(height: 10),
        Text("Video Title here", style: Theme.of(context).textTheme.headline5)
      ];
}

class Playlist extends StatelessWidget {
  final ValueChanged<String> onVideoTap;
  final List<String> videos;

  const Playlist({this.onVideoTap, this.videos});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, idx) => Divider(height: 0),
        itemCount: videos.length,
        itemBuilder: (_, videoIndex) => ListTile(
              onTap: () {
                onVideoTap(videos[videoIndex]);
              },
              leading: Image.network(getVIdeoThumb(videos[videoIndex])),
              title: Text("Video $videoIndex"),
              subtitle: Text('A great video to watch for #flutter devs'),
            ));
  }
}
