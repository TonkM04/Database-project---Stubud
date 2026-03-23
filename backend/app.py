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

@app.route('/groups', methods=["GET"])
def get_groups():
    response = (
        supabase.table("meeting")
        .select("""
            meeting_id,
            start_time,
            end_time,
            meeting_note,
            num_of_students,
            course:course_id(course_name),
            location:location_id(building, room)
        """)
        .order("start_time")
        .execute()
    )

    groups = []
    for row in response.data:
        groups.append({
            "meeting_id": row["meeting_id"],
            "start_time": row["start_time"],
            "end_time": row["end_time"],
            "meeting_note": row["meeting_note"],
            "num_of_students": row["num_of_students"],
            "course_name": row["course"]["course_name"] if row.get("course") else None,
            "building": row["location"]["building"] if row.get("location") else None,
            "room": row["location"]["room"] if row.get("location") else None
        })

    return jsonify(groups), 200

if __name__ == '__main__':
    app.run(debug=True)