import 'package:dim_app_flutter/res.dart';
import 'package:flutter/material.dart';

import 'chat_list.dart';

class MainTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainTabState();
  }
}

class _MainTabState extends State<MainTab> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print('?????');
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [ChatListPage(), ChatListPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
              const BottomNavigationBarItem(
                  icon: Icon(Icons.chat), title: Text('Chat')),
              const BottomNavigationBarItem(
                  icon: Icon(Icons.group), title: Text('Friends'))
            ],
            currentIndex: _tabIndex,
            onTap: (int index) {
              setState(() {
                _tabIndex = index;
              });
              _tabController.animateTo(index);
            },
            fixedColor: kColorPrimary));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
