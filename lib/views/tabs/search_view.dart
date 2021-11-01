import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_case2/bloc/search_bloc.dart';
import 'package:news_case2/elements/error_element.dart';
import 'package:news_case2/elements/loader_element.dart';
import 'package:news_case2/model/article.dart';
import 'package:news_case2/model/article_response.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_case2/style/theme.dart' as style;

import '../news_detail_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            style: const TextStyle(fontSize: 14.0, color: Colors.black),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc.search(_searchController.text);
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              filled: true,
              fillColor: Colors.grey[100],
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        EvaIcons.backspaceOutline,
                        color: Colors.grey[500],
                        size: 16.0,
                      ),
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _searchController.clear();
                          searchBloc.search(_searchController.text);
                        });
                      })
                  : Icon(
                      EvaIcons.searchOutline,
                      color: Colors.grey[500],
                      size: 16.0,
                    ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[100]!.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[100]!.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              contentPadding: const EdgeInsets.only(
                left: 15.0,
                right: 10.0,
              ),
              labelText: "Ara...",
              hintStyle: const TextStyle(
                fontSize: 14.0,
                color: style.Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              labelStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            autocorrect: false,
          ),
        ),
        Expanded(
          child: StreamBuilder<ArticleResponse>(
            stream: searchBloc.subject.stream,
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
        )
      ],
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
                            fontSize: 14.0,
                          ),
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
                                        DateTime.parse(articles[index].date)),
                                    style: const TextStyle(
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.0,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
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
                          ? "http://to-let.com.bd/operator/images/noimage.png"
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


/*

StreamBuilder<ArticleResponse>(
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
    )


 */