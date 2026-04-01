from flask import Blueprint, jsonify

from services.db import supabase

public_bp = Blueprint("public", __name__)


@public_bp.route("/")
def index():
    response = supabase.table("course").select("*").execute()
    return jsonify(response.data)


@public_bp.route("/groups", methods=["GET"])
def get_groups():
    response = (
        supabase.table("meeting")
        .select(
            """
            meeting_id,
            start_time,
            end_time,
            meeting_note,
            num_of_students,
            course:course_id(course_id, course_name),
            location:location_id(location_id, building, room)
        """
        )
        .order("start_time")
        .execute()
    )

    groups = []
    for row in response.data:
        groups.append(
            {
                "meeting_id": row["meeting_id"],
                "start_time": row["start_time"],
                "end_time": row["end_time"],
                "meeting_note": row["meeting_note"],
                "num_of_students": row["num_of_students"],
                "course_id": row["course"]["course_id"] if row.get("course") else None,
                "course_name": row["course"]["course_name"] if row.get("course") else None,
                "location_id": row["location"]["location_id"] if row.get("location") else None,
                "building": row["location"]["building"] if row.get("location") else None,
                "room": row["location"]["room"] if row.get("location") else None,
            }
        )

    return jsonify(groups), 200


@public_bp.route("/courses", methods=["GET"])
def get_courses():
    response = (
        supabase.table("course")
        .select("course_id, course_name")
        .order("course_name")
        .execute()
    )
    return jsonify(response.data), 200
