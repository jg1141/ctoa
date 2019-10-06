import 'package:flutter/material.dart';
import 'data/repository.dart';

class ListItem extends StatelessWidget {
  // var imageSection = new Container(
  //   child: new CircleAvatar(
  //     backgroundImage: new AssetImage('graphics/background.png'),
  //     backgroundColor: Colors.lightGreen,
  //     radius: 24.0,
  //   ),
  // );
  // var titleSection = new Container(child: new Text("Title"));
  // var categorySection = new Container(child: new Text("Category"));
  Articles article;

  ListItem(this.article);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            // child: Image.asset('image-1.jpg', height: 80, width: 80),
            child: Image.network(article.imageUrl, height: 80, width: 80)),
        Container(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(article.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  article.description,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
              ],
            ))
      ],
    );
  }
}
