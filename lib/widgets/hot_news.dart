import 'package:flutter/material.dart';
import 'package:news_case2/bloc/get_hotnews_bloc.dart';
import 'package:news_case2/elements/error_element.dart';
import 'package:news_case2/elements/loader_element.dart';
import 'package:news_case2/model/article.dart';
import 'package:news_case2/model/article_response.dart';
import 'package:news_case2/style/theme.dart' as style;
import 'package:news_case2/views/news_detail_view.dart';
import 'package:timeago/timeago.dart' as timeago;

class HotNewsWidget extends StatefulWidget {
  const HotNewsWidget({Key? key}) : super(key: key);

  @override
  _HotNewsWidgetState createState() => _HotNewsWidgetState();
}

class _HotNewsWidgetState extends State<HotNewsWidget> {
  @override
  void initState() {
    super.initState();
    getHotNewsBloc.getHowNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildHotNewsWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.error.toString());
        } else {
          return buildLoaderWidget();
        }
      },
    );
  }

  Widget _buildHotNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text(
              "No more news",
              style: TextStyle(
                color: Colors.black45,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: articles.length / 2 * 210.0,
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 10.0,
              ),
              child: GestureDetector(
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
                  width: 220.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          1.0,
                          1.0,
                        ),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            image: articles[index].img.isEmpty
                                ? const DecorationImage(
                                    image: AssetImage(
                                      "assets/img/placeholder.jpg",
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(
                                      articles[index].img,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: Text(
                          articles[index].title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            height: 1.3,
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            width: 180,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 30,
                            height: 3.0,
                            color: style.Colors.mainColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                articles[index].source.name,
                                style: const TextStyle(
                                  color: style.Colors.mainColor,
                                  fontSize: 9.0,
                                ),
                              ),
                              Text(
                                timeUntil(
                                  DateTime.parse(articles[index].date),
                                ),
                                style: const TextStyle(
                                    color: Colors.black54, fontSize: 9.0),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
