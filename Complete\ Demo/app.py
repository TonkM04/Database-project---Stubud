from flask import Flask, render_template, redirect, url_for, request
from flask_cors import CORS
import sys
import os

# Add backend directory to path for imports
backend_path = os.path.join(os.path.dirname(__file__), 'backend')
sys.path.insert(0, backend_path)

from routes.auth_routes import auth_bp
from routes.dashboard_routes import dashboard_bp
from routes.profile_routes import profile_bp
from routes.public_routes import public_bp
from routes.groups_and_feedbacks import groups_feedback_bp
from services.db import supabase

app = Flask(__name__, template_folder='templates', static_folder='static', static_url_path='/static')
CORS(app)

# Register blueprints
app.register_blueprint(public_bp)
app.register_blueprint(auth_bp)
app.register_blueprint(profile_bp)
app.register_blueprint(dashboard_bp)
app.register_blueprint(groups_feedback_bp)


# Template rendering routes
@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')


@app.route('/login')
def login_page():
    """Login page"""
    return render_template('login.html')


@app.route('/signup')
def signup_page():
    """Signup page"""
    return render_template('signup.html')


@app.route('/dashboard')
def dashboard_page():
    """Dashboard page - requires authentication"""
    return render_template('dashboard.html')


@app.route('/profile')
def profile_page():
    """Profile page"""
    return render_template('profile.html')


@app.route('/groups')
def groups_page():
    """Groups list page"""
    return render_template('groups.html')


@app.route('/create-group')
def create_group_page():
    """Create group page"""
    return render_template('create-group.html')


@app.route('/group-details')
def group_details_page():
    """Group details page"""
    return render_template('group-details.html')


@app.route('/group-feedback')
def group_feedback_page():
    """Group feedback page"""
    return render_template('group-feedback.html')


@app.route('/join-group')
def join_group_page():
    """Join group page"""
    return render_template('join-group.html')


@app.route('/students')
def students_page():
    """Students list page"""
    return render_template('students.html')


@app.route('/student-info')
def student_info_page():
    """Student info page"""
    return render_template('student-info.html')


@app.route('/logout')
def logout():
    """Logout - clears token"""
    return redirect('/')


# API endpoint for getting students (used by students.html)
@app.route('/api/students', methods=['GET'])
def get_students():
    """Get all students from database"""
    try:
        response = supabase.table('student').select('nyu_email, first_name, last_name, account_role').execute()
        return response.data, 200
    except Exception as e:
        return {'error': str(e)}, 500


# API endpoint for getting students (non-API route for compatibility)
@app.route('/students-api', methods=['GET'])
def api_students():
    """Alternative API endpoint for getting students"""
    try:
        response = supabase.table('student').select('nyu_email, first_name, last_name, account_role').execute()
        return response.data, 200
    except Exception as e:
        return {'error': str(e)}, 500


if __name__ == '__main__':
    app.run(debug=True, port=5000)
