import 'package:flutter/material.dart';
import 'package:news_case2/widgets/headline_slider.dart';
import 'package:news_case2/widgets/hot_news.dart';
import 'package:news_case2/widgets/top_channels.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        HeadlineSliderWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Top Kaynaklar",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        TopChannelsWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Son Dakika",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          ),
        ),
        HotNewsWidget(),
      ],
    );
  }
}
