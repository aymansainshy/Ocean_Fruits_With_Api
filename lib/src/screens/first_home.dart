import 'package:flutter/material.dart';

class FirstHomeScreen extends StatefulWidget {
  static const routeName = '/firs_home_screen';

  @override
  _FirstHomeScreenState createState() => _FirstHomeScreenState();
}

class _FirstHomeScreenState extends State<FirstHomeScreen> {
  PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  List<String> appBarTitle = ["page1", "page1"];

  // void onPageChanged(int page) {
  //   setState(() {
  //     _pageIndex = page;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  final GlobalKey<ScaffoldState> _tapScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<AppBar> appBar = [
      AppBar(
        title: Text("Page 0"),
        // automaticallyImplyLeading: false,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
      ),
      AppBar(
        title: Text("Page 1"),
        // automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _tapScaffoldKey.currentState.openDrawer();
          },
        ),
      ),
    ];

    return Scaffold(
      key: _tapScaffoldKey,
      appBar: appBar[_pageIndex],
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 140,
              color: Colors.grey,
              child: Center(
                child: Text("Drawer"),
              ),
            ),
            ListTile(
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
              title: Text(
                "Page 0",
                style: TextStyle(
                  fontSize: 17,
                  // color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pageController.jumpToPage(0);
              },
            ),
            Divider(),
            ListTile(
              trailing: Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
              title: Text(
                "Page 1",
                style: TextStyle(
                  fontSize: 17,
                  // color: Colors.white,
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _pageController.jumpToPage(1);
              },
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            _pageIndex = index;
          });
        },
        children: <Widget>[
          Page0(),
          Page1(),
        ],
      ),
    );
  }
}

class Page0 extends StatefulWidget {
  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Page 0"));
  }
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> with AutomaticKeepAliveClientMixin {
  int count = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            count++;
          });
        },
      ),
      body: Center(
        child: Text(
          "Page $count",
        ),
      ),
    );
  }
}
