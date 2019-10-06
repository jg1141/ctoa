import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Create a Form widget.
class ProfileSection extends StatefulWidget {
  @override
  ProfileSectionState createState() {
    return ProfileSectionState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class ProfileSectionState extends State<ProfileSection> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<ProfileSectionState>.
  final _formKey = GlobalKey<FormState>();
  var _controller = new TextEditingController();

  String _name = '';

  @override
  void initState() {
    fetchProfile().then(updateName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Center(
            child: Text(
              'Enter CTOA Full Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Center(
            child: RaisedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.

                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Name saved. Restart app for best results.')));
                saveName();
              },
              child: Text('Save Name'),
            ),
          ),
        ),
        Center(
          child: InkWell(
            child: Text("Need an okta account? Create one here.",
                style: TextStyle(fontSize: 16.0, color: Colors.blue)),
            onTap: () {
              _launchURL('https://dev-384355.okta.com/signin/register');
            },
          ),
        ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void saveName() {
    String name = _controller.text;
    _saveProfile(name);
  }

  void updateName(String name) {
    setState(() {
      this._name = name;
      this._controller.text = name;
    });
  }
}

Future<bool> _saveProfile(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('name', name);
}

Future<String> fetchProfile() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String name = await prefs.getString('name') ?? '';
  return name;
}
