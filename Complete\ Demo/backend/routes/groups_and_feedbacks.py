from flask import Blueprint, jsonify, request

from services.db import supabase
from services.auth import require_auth
from services.responses import error_response

groups_feedback_bp = Blueprint("groups_feedback", __name__)


@groups_feedback_bp.route("/api/groups", methods=["GET"])
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


@groups_feedback_bp.route("/api/join-group", methods=["POST"])
@require_auth
def join_group():
    """Join a group (create a meeting_request record)"""
    data = request.get_json(silent=True) or {}
    meeting_id = data.get("meeting_id")

    if not meeting_id:
        return error_response("meeting_id is required", 400)

    try:
        # Check if student is already in this meeting
        existing = (
            supabase.table("meeting_request")
            .select("*")
            .eq("nyu_email", request.user_email)
            .eq("meeting_id", meeting_id)
            .execute()
        )

        if existing.data:
            return error_response("You have already joined this group", 409)

        # Create meeting request
        response = supabase.table("meeting_request").insert(
            {
                "nyu_email": request.user_email,
                "meeting_id": meeting_id,
            }
        ).execute()

        return jsonify(
            {
                "message": "Successfully joined the group",
                "meeting_request": response.data[0] if response.data else None,
            }
        ), 201
    except Exception as exc:
        return error_response(f"Failed to join group: {exc}", 500)


@groups_feedback_bp.route("/api/create-group", methods=["POST"])
def create_group():
    data = request.get_json(silent=True) or {}

    course_name = (data.get("course_name") or "").strip()
    course_id = data.get("course_id")
    start_time = data.get("start_time")
    end_time = data.get("end_time")
    meeting_note = (data.get("meeting_note") or "").strip()
    building = (data.get("building") or "").strip()
    room = (data.get("room") or "").strip()
    capacity = data.get("capacity")

    if not all([course_name, course_id, start_time, end_time, building, room, capacity]):
        return error_response("All fields are required", 400)

    try:
        # Insert course if not exists
        supabase.table("course").insert(
            {"course_id": course_id, "course_name": course_name}
        ).execute()
    except:
        # Course might already exist
        pass

    try:
        # Insert location if not exists
        supabase.table("location").insert(
            {"building": building, "room": room, "capacity": capacity}
        ).execute()
    except:
        # Location might already exist
        pass

    # Get location_id
    location_response = (
        supabase.table("location")
        .select("location_id")
        .eq("building", building)
        .eq("room", room)
        .limit(1)
        .execute()
    )

    if not location_response.data:
        return error_response("Failed to create location", 500)

    location_id = location_response.data[0]["location_id"]

    # Create meeting
    try:
        meeting_response = supabase.table("meeting").insert(
            {
                "start_time": start_time,
                "end_time": end_time,
                "meeting_note": meeting_note,
                "course_id": course_id,
                "location_id": location_id,
            }
        ).execute()

        return jsonify(
            {
                "message": "Group created successfully",
                "meeting": meeting_response.data[0] if meeting_response.data else None,
            }
        ), 201
    except Exception as exc:
        return error_response(f"Failed to create group: {exc}", 500)


@groups_feedback_bp.route("/api/group-feedback", methods=["GET"])
def get_group_feedback():
    meeting_id = request.args.get("meeting_id")
    if not meeting_id:
        return error_response("meeting_id is required", 400)

    response = (
        supabase.table("feedback")
        .select("*")
        .eq("meeting_id", meeting_id)
        .execute()
    )

    return jsonify(response.data), 200


@groups_feedback_bp.route("/api/group-feedback", methods=["POST"])
def create_feedback():
    data = request.get_json(silent=True) or {}

    meeting_id = data.get("meeting_id")
    nyu_email = data.get("nyu_email")
    rating = data.get("rating")
    comment = (data.get("comment") or "").strip()

    if not all([meeting_id, nyu_email, rating]):
        return error_response("meeting_id, nyu_email, and rating are required", 400)

    try:
        feedback_response = supabase.table("feedback").insert(
            {
                "meeting_id": meeting_id,
                "nyu_email": nyu_email,
                "rating": rating,
                "comment": comment,
            }
        ).execute()

        return jsonify(
            {
                "message": "Feedback submitted successfully",
                "feedback": feedback_response.data[0] if feedback_response.data else None,
            }
        ), 201
    except Exception as exc:
        return error_response(f"Failed to submit feedback: {exc}", 500)
