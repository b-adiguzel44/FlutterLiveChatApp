import 'package:flutter/material.dart';
import 'package:flutter_munasaka/app/my_chats_page.dart';
import 'package:flutter_munasaka/app/my_custom_bottom_nav.dart';
import 'package:flutter_munasaka/app/profile.dart';
import 'package:flutter_munasaka/app/tab_items.dart';
import 'package:flutter_munasaka/app/users.dart';
import 'package:flutter_munasaka/model/user_model.dart';
import 'package:flutter_munasaka/viewmodel/all_users_viewmodel.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  final FUser? user;

  HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  TabItem _currentTab = TabItem.Users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.MyChats: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: UsersPage(),
      ),
      TabItem.MyChats: MyChatsPage(),
      TabItem.Profile: ProfilePage(),
    };
  }


  @override
  Widget build(BuildContext context)  {

    return WillPopScope(
        onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!
            .maybePop(),
        child: MyCustomBottomNavigation(
          pageBuilder: allPages(),
          navigatorKeys: navigatorKeys,
          currentTab: _currentTab,
          onSelectedTab: (selectedTab) {

            if(selectedTab == _currentTab) {
              navigatorKeys[selectedTab]!.currentState!.popUntil(
                      (route) => route.isFirst);
            } else {

              setState(() {
                _currentTab = selectedTab;
                // TODO : Temporary fix for MyChatsPage not updating last messages [WILL BE REMOVED - DEPENDING ON RELEASE]
                if (_currentTab == TabItem.MyChats) {
                  (context as Element).reassemble();
                }
              });

            }
            //debugPrint("Choosen Tab : $selectedTab");
          },
        ),
      );

  }
}