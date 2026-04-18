from flask import Blueprint, jsonify
from services.auth import require_auth
from services.db import supabase
from services.responses import error_response

group_feedback_bp = Blueprint("group_feedback", __name__)

@group_feedback_bp.route("/group/<int:meeting_id>/feedback", methods=[GET])
@require_auth
def get_group_feedback(meeting_id):
    try:
        response = (
            supabase.table("feedback")
            .select(
                """
                meeting_id,
                nyu_email,
                rating,
                comment,
                student:nyu_email(nyu_email, first_name, last_name)
                """
            )
            .eq("meeting_id", meeting_id)
            .execute()
        )

        feedback_items = []
        for row in response.data:
            student = row.get("student") or {}
            first_name = student.get("first_name") or ""
            last_name = student.get("last_name") or ""
            full_name = f"{first_name} {last_name}".strip()

            feedback_items.append({
                "meeting_id": row.get("meeting_id"),
                "nyu_email": row.get("nyu_email"),
                "first_name": first_name,
                "last_name": last_name,
                "full_name": full_name if full_name else row.get("nyu_email"),
                "rating": row.get("rating"),
                "comment": row.get("comment") or ""
            })

        return jsonify(feedback_items), 200
    
    except Exception as exc:
        return error_response(f"Failed to fetch feedback: {exc}", 500)
    

@group_feedback_bp.route("/groups/<int:meeting_id>/feedback", methods=["POST"])
@require_auth
def create_group_feedback(meeting_id):
    data = request.get_json(silent=True) or {}

    nyu_email = (data.get("nyu_email") or "").strip().lower()
    rating = data.get("rating")
    comment = (data.get("comment") or "").strip()

    if not nyu_email:
        return error_response("nyu_email is required", 400)
    
    if rating is None:
        return error_response("rating is rquired", 400)
    
    try:
        rating = float(rating)
    except (TypeError, ValueError):
        return error_response("rating must be a number", 400)
    if rating < 0 or rating > 10:
        return error_response("rating must be between 0 and 10", 400)
    
    try:
        member_check = (
            supabase.table("meeting_request")
            .select("nyu_email")
            .eq("meeting_id", meeting_id)
            .eq("nyu_email", nyu_email)
            .limit(1)
            .execute()
        )

        if not member_check.data:
            return error_response("That student is not part of this group", 404)
        
        payload = {
            "meeting_id": meeting_id,
            "nyu_email": nyu_email,
            "rating": rating,
            "comment": comment,
        }

        response = supabase.table("feedback").insert(payload).execute()

        return jsonify({
            "message": "Feedback submitted successfully",
            "feedback": response.data[0] if response.data else payload
        }), 201
    
    except Exception as exc:
        return error_response(f"Failed to submit feedback: {exc}", 500)