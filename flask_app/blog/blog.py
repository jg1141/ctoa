"""Blog functionality."""

from flask import Blueprint, abort, g, render_template, redirect, request, url_for
from flask import jsonify
from slugify import slugify

from .auth import oidc, okta_client
from .db import Post, db

bp = Blueprint("blog", __name__, url_prefix="/")
recent_posts = lambda: Post.query.order_by(Post.created.desc())


@bp.route("/")
def index():
    """
    Render the homepage.
    """
    posts = recent_posts()
    posts_final = []

    for post in posts:
        u = okta_client.get_user(post.author_id)
        post.author_name = u.profile.firstName + " " + u.profile.lastName
        posts_final.append(post)

    return render_template("blog/index.html", posts=posts_final)


@bp.route("/dashboard", methods=["GET", "POST"])
@oidc.require_login
def dashboard():
    """
    Render the dashboard page.
    """
    if request.method == "GET":
        return render_template("blog/dashboard.html", posts=recent_posts())

    post = Post(
        categoryId=request.form.get("categoryId"),
        title=request.form.get("title"),
        articleUrl=request.form.get("articleUrl"),
        imageUrl=request.form.get("imageUrl"),
        description=request.form.get("description"),
        author_id=g.user.id,
        slug=slugify(request.form.get("title"))
    )

    db.session.add(post)
    db.session.commit()

    return render_template("blog/dashboard.html", posts=recent_posts())


@bp.route("/<slug>")
def view_post(slug):
    """View a post."""
    post = Post.query.filter_by(slug=slug).first()
    if not post:
        abort(404)

    u = okta_client.get_user(post.author_id)
    post.author_name = u.profile.firstName + " " + u.profile.lastName

    return render_template("blog/post.html", post=post)


@bp.route("/<slug>/edit", methods=["GET", "POST"])
def edit_post(slug):
    """Edit a post."""
    post = Post.query.filter_by(slug=slug).first()

    if not post:
        abort(404)

    if post.author_id != g.user.id:
        abort(403)

    post.author_name = g.user.profile.firstName + " " + g.user.profile.lastName
    if request.method == "GET":
        return render_template("blog/edit.html", post=post)

    post.categoryId = request.form.get("categoryId")
    post.title = request.form.get("title")
    post.description = request.form.get("description")
    post.articleUrl = request.form.get("articleUrl")
    post.imageUrl = request.form.get("imageUrl")
    post.mediaType = "MediaType.video"
    post.slug = slugify(request.form.get("title"))

    db.session.commit()
    return redirect(url_for(".view_post", slug=post.slug))


@bp.route("/<slug>/delete", methods=["POST"])
def delete_post(slug):
    """Delete a post."""
    post = Post.query.filter_by(slug=slug).first()

    if not post:
        abort(404)

    if post.author_id != g.user.id:
        abort(403)

    db.session.delete(post)
    db.session.commit()

    return redirect(url_for(".dashboard"))


@bp.route('/summary')
def summary():
    # d = {"categoryId": 1,
    #      "id": 1,
    #      "title": "my title here",
    #      "description": "Crescendo Trust YouTube Channel",
    #      "articleUrl": "https://www.youtube.com/user/CrescendoTrust",
    #    "imageUrl": "https://yt3.ggpht.com/a/AGF-l788tRHGrwFIbie4I_uPR8g3OKd9dJBVgt16LA=s288-c-k-c0xffffffff-no-rj-mo",
    #      "mediaType": "MediaType.video"}
    posts = recent_posts()
    posts_final = []
    """
    Aiming for Repository - list of Categories
     Category - has id and name and list of Articles
     Article - has all the rest
    """
    category_dict = {}

    for post in posts[:1]:
        u = okta_client.get_user(post.author_id)
        post.author_name = u.profile.firstName + " " + u.profile.lastName
        if post.categoryId not in category_dict:
            category_dict[post.categoryId] = {'categoryId': str(post.categoryId),
                                              'categoryTitle': str(post.categoryId),
                                              'articles': []}
        post_dict = {'articleUrl': post.articleUrl,
                     'author_name': post.author_name,
                     'created': post.created,
                     'description': post.description,
                     'id': str(post.id),
                     'imageUrl': post.imageUrl,
                     'slug': post.slug,
                     'title': post.title}
        category_dict[post.categoryId]['articles'].append(post_dict)

    for category in category_dict:
        posts_final.append(category_dict[category])

    return jsonify({'categories':posts_final})
    # return jsonify(post_dict)


"""
class Repository {
  static List<Category> categories = [
    Category(
      id: 0,
      title: "Videos",
      articles: [
        Article(
          id: 0,
          categoryId: 0,
          title: "Crescendo Trust YouTube",
          description: "Crescendo Trust YouTube Channel",
          articleUrl: "https://www.youtube.com/user/CrescendoTrust",
          imageUrl: "https://yt3.ggpht.com/a/AGF-l788tRHGrwFIbie4I_uPR8g3OKd9dJBVgt16LA=s288-c-k-c0xffffffff-no-rj-mo",
          mediaType: MediaType.video,
        ),
"""
