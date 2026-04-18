from flask import Blueprint, jsonify
from services.auth import require_auth
from services.db import supabase
from services.responses import error_response

group_details_bp = Blueprint("group_details", __name__)

def _format_group_row(row):
    course = row.get("course") or {}
    location = row.get("location") or {}

    return {
        "meeting_id": row.get("meeting_id"),
        "start_time": row.get("start_time"),
        "end_time": row.get("end_time"),
        "meeting_note": row.get("meeting_note"),
        "num_of_students": row.get("num_of_students"),
        "course_id": row.get("course_id"),
        "course_name": row.get("course_name"),
        "location_id": location.get("location_id"),
        "building": location.get("building"),
        "room": location.get("room"),
        "capacity": location.get("capacity"),
    }

@group_details_bp.route("/groups/<int:meeting_id>", methods=["GET"])
@require_auth
def get_group_details(meeting_id):
    try:
        meeting_response = (
            supabase.table("meeting")
            .select(
                """
                    meeting_id,
                    start_time,
                    end_time,
                    meeting_note,
                    num_of_students,
                    course:course_id(course_id, course_name),
                    location:location_id(location_id, building, room, capacity)
                """
            )
            .eq("meeting_id", meeting_id)
            .limit(1)
            .execute()
        )

        if not meeting_response.data:
            return error_response("Group not found", 404)
        
        group_data = _format_group_row(meeting_response.data[0])

        members_response = (
            supabase.table("meeting_request")
            .select(
                """
                nyu_email,
                student:nyu_email(nyu_email, first_name, last_name)
                """
            )
            .eq("meeting_id", meeting_id)
            .execute()
        )

        students = []
        for row in members_response.data:
            student = row.get("student") or {}
            first_name = student.get("first_name") or ""
            last_name = student.get("last_name") or ""
            full_name = f"{first_name} {last_name}".strip()

            students.append({
                "nyu_email": row.get("nyu_email"),
                "first_name": first_name,
                "last_name": last_name,
                "full_name": full_name if full_name else row.get("nyu_email"),
            })

        feedback_response = (
            supabase.table("feedback")
            .select("rating")
            .eq("meeting_id", meeting_id)
            .execute()
        )

        ratings = [
            float(row["rating"])
            for row in feedback_response.data
            if row.get("rating") is not None
        ]
        average_rating = round(sum(ratings) / len(ratings), 1) if ratings else None

        return jsonify({
            "group": group_data,
            "students": students,
            "rating": average_rating
        }), 200
    
    except Exception as exc:
        return error_response(f"Failed to fetch group details: {exc}", 500)