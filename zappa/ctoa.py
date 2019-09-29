from flask import Flask
from flask import jsonify

app = Flask(__name__)


@app.route('/')
def hello():
    return "Hello World!"

@app.route('/summary')
def summary():
    d = {"userId": 1,
  "id": 1,
  "title": "my title here",
  "body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"}

    return jsonify(d)    

if __name__ == '__main__':
    app.run()