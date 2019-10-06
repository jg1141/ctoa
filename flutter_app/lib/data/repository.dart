class Repository {
  List<Categories> categories;

  Repository({this.categories});

  Repository.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Articles getArticle(int articleId) {
    for (Categories category in categories) {
      for (Articles article in category.articles) {
        if (article.id == articleId) return article;
      }
    }

    // default article, because returning null is evil! :P
    return categories[0].articles[0];
  }
}

class Categories {
  List<Articles> articles;
  String category;

  Categories({this.articles, this.category});

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['articles'] != null) {
      articles = new List<Articles>();
      json['articles'].forEach((v) {
        articles.add(new Articles.fromJson(v));
      });
    }
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.articles != null) {
      data['articles'] = this.articles.map((v) => v.toJson()).toList();
    }
    data['category'] = this.category;
    return data;
  }
}

class Articles {
  String articleUrl;
  String authorName;
  String created;
  String description;
  int id;
  String imageUrl;
  String slug;
  String title;

  Articles(
      {this.articleUrl,
      this.authorName,
      this.created,
      this.description,
      this.id,
      this.imageUrl,
      this.slug,
      this.title});

  Articles.fromJson(Map<String, dynamic> json) {
    articleUrl = json['articleUrl'];
    authorName = json['author_name'];
    created = json['created'];
    description = json['description'];
    id = json['id'];
    imageUrl = json['imageUrl'];
    slug = json['slug'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['articleUrl'] = this.articleUrl;
    data['author_name'] = this.authorName;
    data['created'] = this.created;
    data['description'] = this.description;
    data['id'] = this.id;
    data['imageUrl'] = this.imageUrl;
    data['slug'] = this.slug;
    data['title'] = this.title;
    return data;
  }
}
