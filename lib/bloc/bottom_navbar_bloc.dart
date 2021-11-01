import 'dart:async';

enum NavBarItem { homeTab, sourcesTab, searchTab }

class BottomNavBarBloc {
  final StreamController<NavBarItem> _navBarController =
      StreamController<NavBarItem>.broadcast();
  NavBarItem defaultItem = NavBarItem.homeTab;

  Stream<NavBarItem> get itemStream => _navBarController.stream;

  void pickItem(int i) {
    switch (i) {
      case 0:
        _navBarController.sink.add(NavBarItem.homeTab);
        break;
      case 1:
        _navBarController.sink.add(NavBarItem.sourcesTab);
        break;
      case 2:
        _navBarController.sink.add(NavBarItem.searchTab);
    }
  }

  close() {
    _navBarController.close();
  }
}
