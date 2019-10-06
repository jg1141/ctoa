"""Blog functionality."""

from flask import Blueprint, abort, g, render_template, redirect, request, url_for
from flask import json,Response
from slugify import slugify

from .auth import oidc, okta_client
from .db import Category, Post, db

DEFAULT_IMAGEURL = "http://ec2-52-63-254-177.ap-southeast-2.compute.amazonaws.com:5000/static/placeholder.jpg"
ADMIN_AUTHOR_ID = "00u1iuuhdfKa65SeN357"

bp = Blueprint("blog", __name__, url_prefix="/")


def recent_posts(authorid = ''):
    if authorid == ADMIN_AUTHOR_ID:
        # No Filter
        return Post.query.order_by(Post.created.desc())
    else:
        return Post.query.filter_by(author_id=authorid).order_by(Post.created.desc())



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


def add_defaults(post):
    if len(post.imageUrl.strip()) == 0:
        post.imageUrl = DEFAULT_IMAGEURL
    return post


@bp.route("/dashboard", methods=["GET", "POST"])
@oidc.require_login
def dashboard():
    """
    Render the dashboard page.
    """
    categories = []
    cats = Category.query.order_by(Category.created.desc())
    for cat in cats:
        categories.append(cat.category)

    if request.method == "GET":
        return render_template("blog/dashboard.html", posts=recent_posts(g.user.id), categories=categories)

    post = Post(
        category=request.form.get("category"),
        title=request.form.get("title"),
        articleUrl=request.form.get("articleUrl"),
        imageUrl=request.form.get("imageUrl"),
        description=request.form.get("description"),
        author_id=g.user.id,
        slug=slugify(request.form.get("title")),
        forName=request.form.get("forName")
    )

    post = add_defaults(post)

    db.session.add(post)
    db.session.commit()

    return render_template("blog/dashboard.html", posts=recent_posts(g.user.id), categories=categories)


@bp.route("/<slug>")
@oidc.require_login
def view_post(slug):
    """View a post."""
    post = Post.query.filter_by(slug=slug).first()
    if not post:
        abort(404)

    u = okta_client.get_user(post.author_id)
    post.author_name = u.profile.firstName + " " + u.profile.lastName

    return render_template("blog/post.html", post=post)


@bp.route("/<slug>/edit", methods=["GET", "POST"])
@oidc.require_login
def edit_post(slug):
    """Edit a post."""
    post = Post.query.filter_by(slug=slug).first()

    if not post:
        abort(404)

    if post.author_id != g.user.id:
        if g.user.id == ADMIN_AUTHOR_ID:
            pass
        else:
            abort(403)

    post.author_name = g.user.profile.firstName + " " + g.user.profile.lastName

    categories = []
    cats = Category.query.order_by(Category.created.desc())
    for cat in cats:
        categories.append(cat.category)

    if request.method == "GET":
        return render_template("blog/edit.html", post=post, categories=categories)
    post.category = request.form.get("category")
    post.title = request.form.get("title")
    post.description = request.form.get("description")
    post.articleUrl = request.form.get("articleUrl")
    post.imageUrl = request.form.get("imageUrl")
    post.forName = request.form.get("forName")
    post.slug = slugify(request.form.get("title"))

    post = add_defaults(post)

    db.session.commit()
    return redirect(url_for(".view_post", slug=post.slug))


@bp.route("/categories", methods=["GET", "POST"])
@oidc.require_login
def edit_categories():
    """Edit categories."""
    categories = []
    cats = Category.query.order_by(Category.created.desc())
    for cat in cats:
        categories.append(cat.category)
        db.session.delete(cat)
    category_list = ','.join(categories)

    if not category_list:
        abort(404)

    # if post.author_id != g.user.id:
    #     abort(403)
    #
    # post.author_name = g.user.profile.firstName + " " + g.user.profile.lastName

    if request.method == "GET":
        return render_template("blog/edit_categories.html", category_list=category_list)

    # POST - delete all current categories
    cats = Category.query.order_by(Category.created.desc())
    for cat in cats:
        db.session.delete(cat)
        db.session.commit()

    category_list = request.form.get("category_list")
    new_cats = category_list.split(',')
    new_cats = sorted([item.strip() for item in new_cats], reverse=True)
    for cat in new_cats:
        cat_record = Category(
            category=cat
        )
        db.session.add(cat_record)
        db.session.commit()

    return redirect(url_for(".dashboard"))


@bp.route("/<slug>/delete", methods=["POST"])
@oidc.require_login
def delete_post(slug):
    """Delete a post."""
    post = Post.query.filter_by(slug=slug).first()

    if not post:
        abort(404)

    if post.author_id != g.user.id:
        if g.user.id == ADMIN_AUTHOR_ID:
            pass
        else:
            abort(403)

    db.session.delete(post)
    db.session.commit()

    return redirect(url_for(".dashboard"))


@bp.route('/summary')
@bp.route('/summary/<for_name>')
def summary(for_name=''):
    # d = {"category": 1,
    #      "id": 1,
    #      "title": "my title here",
    #      "description": "Crescendo Trust YouTube Channel",
    #      "articleUrl": "https://www.youtube.com/user/CrescendoTrust",
    #    "imageUrl": "https://yt3.ggpht.com/a/AGF-l788tRHGrwFIbie4I_uPR8g3OKd9dJBVgt16LA=s288-c-k-c0xffffffff-no-rj-mo",
    #      "mediaType": "MediaType.video"}
    posts = recent_posts(authorid=ADMIN_AUTHOR_ID)  # Subject to forName filter below
    posts_final = []
    """
    Aiming for Repository - list of Categories
     Category - has id and name and list of Articles
     Article - has all the rest
    """
    category_dict = {}

    for post in posts:
        if len(post.forName.strip()) > 0:
            if post.forName.strip() == for_name:
                pass
            else:
                continue
        u = okta_client.get_user(post.author_id)
        post.author_name = u.profile.firstName + " " + u.profile.lastName
        if post.category not in category_dict:
            category_dict[post.category] = {'category': post.category, 'articles': []}
        post_dict = {'articleUrl': post.articleUrl,
                     'author_name': post.author_name,
                     'created': post.created,
                     'description': post.description,
                     'id': post.id,
                     'imageUrl': post.imageUrl,
                     'slug': post.slug,
                     'title': post.title}
        category_dict[post.category]['articles'].append(post_dict)

    for category in category_dict:
        posts_final.append(category_dict[category])

    json_string = json.dumps({'categories': posts_final}, ensure_ascii=False)
    # creating a Response object to set the content type and the encoding
    response = Response(json_string, content_type="application/json; charset=utf-8" )
    return response
    # return jsonify()
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
          category: 0,
          title: "Crescendo Trust YouTube",
          description: "Crescendo Trust YouTube Channel",
          articleUrl: "https://www.youtube.com/user/CrescendoTrust",
          imageUrl: "https://yt3.ggpht.com/a/AGF-l788tRHGrwFIbie4I_uPR8g3OKd9dJBVgt16LA=s288-c-k-c0xffffffff-no-rj-mo",
          mediaType: MediaType.video,
        ),
"""
