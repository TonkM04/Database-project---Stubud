import os
from flask import Flask, jsonify
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

supabase: Client = create_client(
    os.environ.get("SUPABASE_URL"),
    os.environ.get("SUPABASE_KEY")
)

@app.route('/')
def index():
    response = supabase.table('course').select("*").execute()
    return jsonify(response.data)

if __name__ == '__main__':
    app.run(debug=True)