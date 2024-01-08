import 'package:flutter/material.dart';

// index no : 0 - Users
// index no : 1 - Profile
enum TabItem {Users, MyChats, Profile}

class TabItemData {

  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> allTabs = {

    TabItem.Users: TabItemData("Kullanıcılar", Icons.supervised_user_circle),
    TabItem.MyChats: TabItemData("Sohbetlerim", Icons.chat),
    TabItem.Profile: TabItemData("Profil", Icons.person),

  };

}