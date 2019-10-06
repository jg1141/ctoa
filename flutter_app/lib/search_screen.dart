//import 'package:flutter/material.dart';
//import 'package:flutter_app/data/repository.dart';
//import 'list_item.dart';
//
//class SearchScreen extends StatefulWidget {
//  @override
//  _SearchListExampleState createState() => new _SearchListExampleState();
//}
//
//class _SearchListExampleState extends State<SearchScreen> {
//  Widget appBarTitle = new Text(
//    "Search Example",
//    style: new TextStyle(color: Colors.white),
//  );
//  Icon icon = new Icon(
//    Icons.search,
//    color: Colors.white,
//  );
//  final globalKey = new GlobalKey<ScaffoldState>();
//  final TextEditingController _controller = new TextEditingController();
//  List<dynamic> _list, _item_list;
//  bool _isSearching;
//  String _searchText = "";
//  List searchresult = new List();
//  List articleList = Repository.categories[0].articles;
//
//  _SearchListExampleState() {
//    _controller.addListener(() {
//      if (_controller.text.isEmpty) {
//        setState(() {
//          _isSearching = false;
//          _searchText = "";
//        });
//      } else {
//        setState(() {
//          _isSearching = true;
//          _searchText = _controller.text;
//        });
//      }
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    _isSearching = false;
//    values();
//  }
//
//  void values() {
//    _list = List();
//    _list.add("article");
//    _list.add("video");
//    _list.add("podcast");
//  }
//
//  void list_items() {
//    List articleList = Repository.categories[0].articles;
//    _item_list = List();
//    for (Article article in articleList) {
//      _item_list.add(article);
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      key: globalKey,
//      appBar: buildAppBar(context),
//      // body: new Container(
//      //   child: new Column(
//      //     crossAxisAlignment: CrossAxisAlignment.start,
//      //     mainAxisSize: MainAxisSize.min,
//      //     children: <Widget>[
//      //       new Flexible(
//      //         child: searchresult.length != 0 || _controller.text.isNotEmpty
//      //             ? buildSearchResult(context)
//      //             : buildDefaultResult(context),
//      //       )
//      //     ],
//      //   ),
//      // ),
//      body: buildDefaultResult(context),
//    );
//  }
//
//  Widget buildSearchResult(BuildContext context) {
//    return ListView.builder(
//      shrinkWrap: true,
//      itemCount: searchresult.length,
//      itemBuilder: (BuildContext context, int index) {
//        String listData = searchresult[index];
//        return new ListTile(
//          title: new Text(listData.toString()),
//        );
//      },
//    );
//  }
//
//  Widget buildDefaultResult(BuildContext context) {
//    return ListView.builder(
//      shrinkWrap: true,
//      itemCount: articleList.length,
//      itemBuilder: (BuildContext context, int index) {
//        return new ListItem(articleList[index]);
//      },
//    );
//  }
//
//  Widget buildAppBar(BuildContext context) {
//    return new AppBar(centerTitle: true, title: appBarTitle, actions: <Widget>[
//      new IconButton(
//        icon: icon,
//        onPressed: () {
//          setState(() {
//            if (this.icon.icon == Icons.search) {
//              this.icon = new Icon(
//                Icons.close,
//                color: Colors.white,
//              );
//              this.appBarTitle = new TextField(
//                controller: _controller,
//                style: new TextStyle(
//                  color: Colors.white,
//                ),
//                decoration: new InputDecoration(
//                    prefixIcon: new Icon(Icons.search, color: Colors.white),
//                    hintText: "Search...",
//                    hintStyle: new TextStyle(color: Colors.white)),
//                onChanged: searchOperation,
//              );
//              _handleSearchStart();
//            } else {
//              _handleSearchEnd();
//            }
//          });
//        },
//      ),
//    ]);
//  }
//
//  void _handleSearchStart() {
//    setState(() {
//      _isSearching = true;
//    });
//  }
//
//  void _handleSearchEnd() {
//    setState(() {
//      this.icon = new Icon(
//        Icons.search,
//        color: Colors.white,
//      );
//      this.appBarTitle = new Text(
//        "Search Sample",
//        style: new TextStyle(color: Colors.white),
//      );
//      _isSearching = false;
//      _controller.clear();
//    });
//  }
//
//  void searchOperation(String searchText) {
//    searchresult.clear();
//    if (_isSearching != null) {
//      for (int i = 0; i < _list.length; i++) {
//        String data = _item_list[i];
//        if (data.toLowerCase().contains(searchText.toLowerCase())) {
//          searchresult.add(data);
//        }
//      }
//    }
//  }
//}
