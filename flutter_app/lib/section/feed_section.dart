import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/data/repository.dart';
import 'package:flutter_app/detail_screen.dart';

class _FeedSectionState extends State<FeedSection> {

  @override
  Widget build(BuildContext context) {
    int categoryIndex = 0;
    List<Categories> cats = widget.repository.categories;
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: cats.length,
      itemBuilder: (context, i) {
        Categories category = cats[i];
        return _buildCarousel(category, categoryIndex++);
      },
    );
  }

  Widget _buildCarousel(Categories category, int categoryIndex) {
    int cardIndex = 0;
    return Column(
      children: <Widget>[
        Container(
            alignment: Alignment.topLeft,
            child: Text(category.category,
                style: new TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0))),
        CarouselSlider(
            viewportFraction: 1 / 3,
            items: category.articles.map((article) {
              return Builder(
                builder: (BuildContext context) {
                  return _buildCard(article, cardIndex++, categoryIndex);
                },
              );
            }).toList())
      ],
    );
  }

  Widget _buildImage(imageUrl, String heroTag) {
    return SizedBox(
        width: 125,
        height: 125,
        child: Hero(
            tag: heroTag, child: FittedBox(fit: BoxFit.contain, child:Image.network(imageUrl, ))));
  }

  Widget _buildCard(Articles article, int cardIndex, int categoryIndex) {
    String heroTag = cardIndex.toString() + ":" + categoryIndex.toString();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        child: Column(children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              GestureDetector(
                child: _buildImage(article.imageUrl, heroTag),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                              repository: widget.repository,
                              articleId: article.id,
                              heroTag: heroTag,
                            )),
                  );
                },
              ),
//              IconButton(
//                icon: Icon(article.isFavourite
//                    ? Icons.favorite
//                    : Icons.favorite_border),
//                onPressed: () {
//                  setState(() {
//                    if (article.isFavourite) {
//                      article.isFavourite = false;
//                    } else {
//                      article.isFavourite = true;
//                    }
//                  });
//                },
//              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Text(article.title,
                overflow: TextOverflow.ellipsis, maxLines: 3),
          ),
        ]));
  }
}

class FeedSection extends StatefulWidget {
  Repository repository;

  FeedSection({Key key, this.repository}) : super(key: key);

  @override
  _FeedSectionState createState() => _FeedSectionState();
}
