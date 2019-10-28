import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/repository.dart';

class DetailScreen extends StatefulWidget {
  Repository repository;
  Articles article;
  String heroTag;

  DetailScreen({
    @required Repository repository,
    @required int articleId,
    @required String heroTag,
  }) {
    article = repository.getArticle(articleId);
    this.heroTag = heroTag; // Not sure why I need to do this.<field> on this line but not on the previous.
  }

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.article.title),
          actions: <Widget>[
            // Add 3 lines from here...
//            IconButton(
//              icon: Icon(widget.article.isFavourite
//                  ? Icons.favorite
//                  : Icons.favorite_border),
//              onPressed: () {
//                setState(() {
//                  if (widget.article.isFavourite) {
//                    widget.article.isFavourite = false;
//                  } else {
//                    widget.article.isFavourite = true;
//                  }
//                });
//              },
//            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
                  tag: widget.heroTag,
                  child: Image.network(
                    widget.article.imageUrl,
                  )),
              Row(
                children: <Widget>[
                  Spacer(),
                  Container(
                    child: FloatingActionButton(
                      child: Icon(Icons.screen_share),
                      onPressed: () {
                        launch(widget.article.articleUrl);
                      },
                      backgroundColor: Colors.red,
                    ),
                    transform: Matrix4.translationValues(-16.0, -30.0, 0.0),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(40.0),
                transform: Matrix4.translationValues(0.0, -60.0, 0.0),
                child: Column(
                  children: <Widget>[
                    Table(
                      children: <TableRow>[
                        TableRow(children: [
                          Text("Summary:\n"),
                        ]),
                        TableRow(children: [
                          Text(widget.article.description)
                        ]),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
