"""Database tools and helpers."""


from datetime import datetime

from click import command, echo
from flask_sqlalchemy import SQLAlchemy
from flask.cli import with_appcontext


db = SQLAlchemy()


class Post(db.Model):
    """A blog post."""
    id = db.Column(db.Integer, primary_key=True)
    author_id = db.Column(db.Text, nullable=False)
    category = db.Column(db.Text, nullable=False)
    created = db.Column(db.DateTime, default=datetime.utcnow)
    slug = db.Column(db.Text, nullable=False)
    title = db.Column(db.Text, nullable=False)
    description = db.Column(db.Text, nullable=True)
    articleUrl = db.Column(db.Text, nullable=True)
    imageUrl = db.Column(db.Text, nullable=True)
    mediaType = db.Column(db.Text, nullable=True)

    def __repr__(self):
        return "<Post %r (%r)>" % (self.title, self.created)


class Category(db.Model):
    """A post category."""
    categoryId = db.Column(db.Integer, primary_key=True)
    category = db.Column(db.Text, nullable=False)
    created = db.Column(db.DateTime, default=datetime.utcnow)

    def __repr__(self):
        return "<Category %r (%r)>" % (self.categoryId, self.created)


@command("init-db")
@with_appcontext
def init_db_command():
    """Initialize the database."""
    db.create_all()
    echo("Initialized the database.")


def init_app(app):
    """Initialize the Flask app for database usage."""
    db.init_app(app)
    app.cli.add_command(init_db_command)
