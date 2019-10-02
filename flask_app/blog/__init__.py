"""
A simple Flask blog.
"""


from os import environ
from os.path import dirname, join

from flask import Flask, g, render_template

from . import auth, db, blog


app = Flask(__name__, instance_relative_config=True)
app.config.from_mapping(
    SECRET_KEY="jRsQQmUWmuoxXbqk99IPjeGPll0-eKx5Q6ostaZj",
    SQLALCHEMY_TRACK_MODIFICATIONS=False,
    SQLALCHEMY_DATABASE_URI="sqlite:///" + join(dirname(dirname(__file__)), "database.sqlite"),
    DEBUG=True,
    OIDC_CLIENT_SECRETS=join(dirname(dirname(__file__)), "client_secrets.json"),
    OIDC_COOKIE_SECURE=False,
    OIDC_CALLBACK_ROUTE="/oidc/callback",
    OIDC_SCOPES=["openid", "email", "profile"],
    OIDC_ID_TOKEN_COOKIE_NAME="oidc_token",
)
auth.oidc.init_app(app)
db.init_app(app)

app.register_blueprint(auth.bp)
app.register_blueprint(blog.bp)

app.config['JSON_AS_ASCII'] = False


@app.before_request
def before_request():
    """
    Load a proper user object using the user ID from the ID token. This way, the
    `g.user` object can be used at any point.
    """
    if auth.oidc.user_loggedin:
        g.user = auth.okta_client.get_user(auth.oidc.user_getfield("sub"))
    else:
        g.user = None


@app.errorhandler(404)
def page_not_found(e):
    """Render a 404 page."""
    return render_template("404.html"), 404


@app.errorhandler(403)
def insufficient_permissions(e):
    """Render a 403 page."""
    return render_template("403.html"), 403


if __name__ == '__main__':
    app.run(host='0.0.0.0')
