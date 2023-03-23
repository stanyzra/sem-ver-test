from flask import Flask

app = Flask(__name__)


@app.route('/')
def index():
    return 'Hello, world!'


@app.route('/about')
def about():
    return 'This is the about page.'


@app.route('/users/<username>')
def user_profile(username):
    return f'This is the profile page for {username}.'


if __name__ == '__main__':
    app.run(debug=True)
