from flask import Flask
from flask_cors import CORS

from routes.auth_routes import auth_bp
from routes.dashboard_routes import dashboard_bp
from routes.profile_routes import profile_bp
from routes.public_routes import public_bp

app = Flask(__name__)
CORS(app)

app.register_blueprint(public_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(dashboard_bp)


if __name__ == "__main__":
    app.run(debug=True)
