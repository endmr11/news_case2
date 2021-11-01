import 'package:flutter/material.dart';
import 'package:news_case2/bloc/get_source_news_bloc.dart';
import 'package:news_case2/elements/error_element.dart';
import 'package:news_case2/elements/loader_element.dart';
import 'package:news_case2/model/article.dart';
import 'package:news_case2/model/article_response.dart';
import 'package:news_case2/model/source.dart';
import 'package:news_case2/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

import 'news_detail_view.dart';

class SourceDetail extends StatefulWidget {
  const SourceDetail({Key? key, required this.source}) : super(key: key);

  final SourceModel source;

  @override
  // ignore: no_logic_in_create_state
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;
  _SourceDetailState(this.source);
  @override
  void initState() {
    super.initState();
    getSourceNewsBloc.getSourceNews(source.id);
  }

  @override
  void dispose() {
    super.dispose();
    getSourceNewsBloc.drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: style.Colors.mainColor,
          title: Text(source.name),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id,
                  child: SizedBox(
                      height: 80.0,
                      width: 80.0,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2.0, color: Colors.white),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/logos/${source.id}.png"),
                                fit: BoxFit.cover)),
                      )),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<ArticleResponse>(
              stream: getSourceNewsBloc.subject.stream,
              builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.error.isNotEmpty) {
                    return buildErrorWidget(snapshot.data!.error);
                  }
                  return _buildSourceNewsWidget(snapshot.data!);
                } else if (snapshot.hasError) {
                  return buildErrorWidget(snapshot.error.toString());
                } else {
                  return buildLoaderWidget();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailNews(
                    article: articles[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                color: Colors.white,
              ),
              height: 150,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10.0,
                      left: 10.0,
                      bottom: 10.0,
                      right: 10.0,
                    ),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articles[index].title,
                          maxLines: 3,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14.0),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      timeUntil(
                                        DateTime.parse(articles[index].date),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.black26,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130,
                    child: FadeInImage.assetNetwork(
                      alignment: Alignment.topCenter,
                      placeholder: 'assets/img/placeholder.jpg',
                      image: articles[index].img.isEmpty
                          ? "https://xn--80aadc3bb0afph5eue.xn--p1ai/images/no_photo.png"
                          : articles[index].img,
                      fit: BoxFit.fitHeight,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(
      date,
      allowFromNow: true,
      locale: 'en',
    );
  }
}
