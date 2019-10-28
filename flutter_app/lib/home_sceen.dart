import 'package:flutter/material.dart';
import 'package:flutter_app/search_screen.dart';

//import 'package:flutter_app/section/bookmarks_section.dart';
import 'package:flutter_app/section/feed_section.dart';
import 'package:flutter_app/section/profile_section.dart';
import 'package:flutter_app/section/about_section.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'data/repository.dart';

Future<Repository> fetchRepository() async {
  String _name = await fetchProfile();

  if (_name.length > 0) {_name = '/' + _name;}

  final response = await http.get(Uri.encodeFull('http://ec2-52-63-254-177.ap-southeast-2.compute.amazonaws.com:5000/summary' + _name));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON. .decode(utf8.decode(response.bodyBytes))
    return Repository.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class HomeScreen extends StatefulWidget {
  final Future<Repository> repository;

  HomeScreen({Key key, this.repository}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String _name = 'CTOA';
  var _controller = new TextEditingController();

  @override
  void initState() {
    fetchProfile().then(updateName);
    super.initState();
  }

  void updateName(String name) {
    setState(() {
      if (name == '') {
        this._name = 'CTOA';
      } else {
        this._name = name;
      }
      this._controller.text = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
        actions: <Widget>[
          // Add 3 lines from here...
//          IconButton(
//              icon: Icon(Icons.search),
//              onPressed: () {
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(builder: (context) => SearchScreen()),
//                );
//              }),
        ],
      ),
      body: FutureBuilder<Repository>(
        future: widget.repository,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_currentIndex == 0) {
              return FeedSection(repository: snapshot.data);
            } else if (_currentIndex == 1) {
              return ProfileSection();
            } else if (_currentIndex == 2) {
              return AboutSection();
            }
            ;
//            return _children[_currentIndex];
//            return Text(snapshot.data.categories.first.articles.first.description);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner.
          return Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Feed'),
//            backgroundColor: Colors.red, // changes all backgrounds
          ),
//          BottomNavigationBarItem(
//            icon: new Icon(Icons.bookmark),
//            title: new Text('Bookmarks'),
//          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            title: Text('About'),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
