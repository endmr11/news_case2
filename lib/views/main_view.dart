import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:news_case2/bloc/bottom_navbar_bloc.dart';
import 'package:news_case2/style/theme.dart' as style;
import 'package:news_case2/views/tabs/home_view.dart';
import 'package:news_case2/views/tabs/search_view.dart';
import 'package:news_case2/views/tabs/sources_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late BottomNavBarBloc _bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: style.Colors.mainColor,
          title: const Text(
            "Haberler",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            // ignore: prefer_typing_uninitialized_variables
            var returnWidget;
            if (snapshot.data != null) {
              if (snapshot.data == NavBarItem.homeTab) {
                returnWidget = const HomeView();
              } else if (snapshot.data == NavBarItem.sourcesTab) {
                returnWidget = const SourcesView();
              } else if (snapshot.data == NavBarItem.searchTab) {
                returnWidget = const SearchView();
              }
            } else {
              return const CircularProgressIndicator();
            }
            return returnWidget;
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 0,
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                iconSize: 20,
                unselectedItemColor: style.Colors.titleColor,
                unselectedFontSize: 9.5,
                selectedFontSize: 9.5,
                type: BottomNavigationBarType.fixed,
                fixedColor: style.Colors.mainColor,
                currentIndex: snapshot.data!.index,
                onTap: _bottomNavBarBloc.pickItem,
                items: const [
                  BottomNavigationBarItem(
                    label: "Anasayfa",
                    icon: Icon(
                      EvaIcons.homeOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.home,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Kaynaklar",
                    icon: Icon(
                      EvaIcons.gridOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.grid,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "Arama",
                    icon: Icon(
                      EvaIcons.searchOutline,
                    ),
                    activeIcon: Icon(
                      EvaIcons.search,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
