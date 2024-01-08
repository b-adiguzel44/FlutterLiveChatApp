import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/tab_items.dart';

class MyCustomBottomNavigation extends StatelessWidget {

  const MyCustomBottomNavigation({super.key,
    required this.currentTab,
    required this.onSelectedTab,
    required this.pageBuilder,
    required this.navigatorKeys,
  });

  final TabItem? currentTab;
  final ValueChanged<TabItem>? onSelectedTab;
  final Map<TabItem, Widget> pageBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;




  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildTabItem(TabItem.Users),
          _buildTabItem(TabItem.MyChats),
          _buildTabItem(TabItem.Profile),
        ],
        onTap: (index) => onSelectedTab!(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final showItem = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[showItem],
          builder: (context) {
            return pageBuilder[showItem]!;
          }
        );
      },
    );
  }

  BottomNavigationBarItem _buildTabItem(TabItem tabItem) {

    final buildableTab =  TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
      icon: Icon(buildableTab!.icon),
      label: buildableTab.title,
    );
  }

}
