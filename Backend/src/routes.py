import json
from db import db, User, Event
from flask import Flask, request
import users_dao

db_filename = "ff.db"
app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()


def extract_token(request):
    auth_header = request.headers.get('Authorization')
    if auth_header is None:
        return False, json.dumps({'error': 'Missing authorization header.'})

    # Header looks like "Authorization: Bearer <session token>"
    bearer_token = auth_header.replace('Bearer ', '').strip()
    if bearer_token is None or not bearer_token:
        return False, json.dumps({'error': 'Invalid authorization header.'})

    return True, bearer_token


@app.route('/')
def hello_world():
    return json.dumps({'message': 'Hello, World!'})


@app.route('/register/', methods=['POST'])
def register_account():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')
    username = post_body.get('username')

    if email is None or password is None:
        return json.dumps({'error': 'Invalid email or password'})

    created, user = users_dao.create_user(email, password, username)

    if not created:
        return json.dumps({'error': 'User already exists.'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route('/login/', methods=['POST'])
def login():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if email is None or password is None:
        return json.dumps({'error': 'Invalid email or password'})

    success, user = users_dao.verify_credentials(email, password)

    if not success:
        return json.dumps({'error': 'Incorrect email or password.'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route('/session/', methods=['POST'])
def update_session():
    success, update_token = extract_token(request)

    if not success:
        return update_token

    try:
        user = users_dao.renew_session(update_token)
    except:
        return json.dumps({'error': 'Invalid update token.'})

    return json.dumps({
        'session_token': user.session_token,
        'session_expiration': str(user.session_expiration),
        'update_token': user.update_token
    })


@app.route('/secret/', methods=['GET'])
def secret_message():
    success, session_token = extract_token(request)

    if not success:
        return session_token

    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'error': 'Invalid session token.'})

    return json.dumps({
        'message': 'You have successfully implemented sessions.',
        'id': user.id,
        'username': user.username
    })


@app.route('/api/')
def hello_world_again():
    return json.dumps({'message': 'Hello, World!'})


# only for testing uses: generate event
@app.route('/api/', methods=['POST'])
def post_test_events():
    post_body = json.loads(request.data)
    name = post_body.get('name')
    location = post_body.get('location')
    time = post_body.get('time')
    content = post_body.get('content')
    event = Event(name=name, location=location, time=time, content=content)
    db.session.add(event)
    db.session.commit()
    return json.dumps({'success': True, 'data': event.serialize()})


@app.route('/api/user/<int:user_id>/events/', methods=['GET'])
def get_events(user_id):
    user = users_dao.get_user_by_id(user_id)
    if not user:
        return json.dumps({'error': 'Invalid User'})
    events = [event.serialize() for event in user.event]
    return json.dumps({
        'success': True,
        'data': events
    })


@app.route('/api/user/<int:user_id>/events/', methods=['POST'])
def post_events(user_id):
    user = users_dao.get_user_by_id(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404
    post_body = json.loads(request.data)
    event_id = post_body.get('id')
    event = Event.query.filter_by(id=event_id).first()
    user.event.append(event)
    db.session.commit()
    return json.dumps({'success': True, 'data': event.serialize()})


@app.route('/api/user/<int:user_id>/events/<int:event_id>/', methods=['DELETE'])
def delete_event(user_id, event_id):
    user = users_dao.get_user_by_id(user_id)
    if not user:
        return json.dumps({'success': False, 'error': 'User not found!'}), 404
    event = Event.query.filter_by(id=event_id).first()
    if not event:
        return json.dumps({'success': False, 'error': 'Event not found!'}), 404
    user.event.remove(event)
    db.session.commit()
    return json.dumps({'success': True, 'data': event.serialize()})


@app.route('/api/user/events/', methods=['GET'])
def get_all_events():
    events = Event.query.all()
    res = {'success': True, 'data': [event.serialize() for event in events]}
    return json.dumps(res), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
