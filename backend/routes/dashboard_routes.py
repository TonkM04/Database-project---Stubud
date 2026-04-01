from flask import Blueprint, jsonify, request

from services.auth import require_auth
from services.db import supabase
from services.responses import error_response
from services.student_service import fetch_profile_bundle

dashboard_bp = Blueprint("dashboard", __name__)


@dashboard_bp.route("/dashboard", methods=["GET"])
@require_auth
def get_dashboard():
    profile = fetch_profile_bundle(request.user_email)
    if not profile:
        return error_response("Student not found", 404)

    meeting_response = (
        supabase.table("meeting_request")
        .select(
            """
            meeting_id,
            meeting:meeting_id(
                meeting_id,
                start_time,
                end_time,
                meeting_note,
                num_of_students,
                course:course_id(course_id, course_name),
                location:location_id(location_id, building, room)
            )
        """
        )
        .eq("nyu_email", request.user_email)
        .execute()
    )

    joined_groups = []
    for row in meeting_response.data:
        meeting = row.get("meeting") or {}
        course = meeting.get("course") or {}
        location = meeting.get("location") or {}
        joined_groups.append(
            {
                "meeting_id": meeting.get("meeting_id"),
                "start_time": meeting.get("start_time"),
                "end_time": meeting.get("end_time"),
                "meeting_note": meeting.get("meeting_note"),
                "num_of_students": meeting.get("num_of_students"),
                "course_id": course.get("course_id"),
                "course_name": course.get("course_name"),
                "location_id": location.get("location_id"),
                "building": location.get("building"),
                "room": location.get("room"),
            }
        )

    upcoming_groups = sorted(
        joined_groups,
        key=lambda group: group["start_time"] or "",
    )

    dashboard = {
        "student": profile["student"],
        "courses": profile["courses"],
        "available_times": profile["available_times"],
        "joined_groups": upcoming_groups,
        "stats": {
            "course_count": len(profile["courses"]),
            "joined_group_count": len(upcoming_groups),
        },
    }

    return jsonify(dashboard), 200
