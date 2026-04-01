from services.db import supabase


def fetch_student_or_none(nyu_email):
    response = (
        supabase.table("student")
        .select("nyu_email, first_name, last_name, hashed_password, account_role")
        .eq("nyu_email", nyu_email)
        .limit(1)
        .execute()
    )
    return response.data[0] if response.data else None


def fetch_profile_bundle(nyu_email):
    student_response = (
        supabase.table("student")
        .select("nyu_email, first_name, last_name, account_role")
        .eq("nyu_email", nyu_email)
        .limit(1)
        .execute()
    )

    if not student_response.data:
        return None

    course_response = (
        supabase.table("student_course")
        .select("course_id, course:course_id(course_id, course_name)")
        .eq("nyu_email", nyu_email)
        .order("course_id")
        .execute()
    )

    available_time_response = (
        supabase.table("student_available_time")
        .select("time_id, week_day, start_time, end_time")
        .eq("nyu_email", nyu_email)
        .order("week_day")
        .order("start_time")
        .execute()
    )

    return {
        "student": student_response.data[0],
        "courses": [
            {
                "course_id": row["course_id"],
                "course_name": row["course"]["course_name"] if row.get("course") else None,
            }
            for row in course_response.data
        ],
        "available_times": available_time_response.data,
    }


def get_next_time_id():
    response = (
        supabase.table("student_available_time")
        .select("time_id")
        .order("time_id", desc=True)
        .limit(1)
        .execute()
    )
    if not response.data:
        return 1
    return response.data[0]["time_id"] + 1


def replace_courses(nyu_email, course_ids):
    (
        supabase.table("student_course")
        .delete()
        .eq("nyu_email", nyu_email)
        .execute()
    )

    unique_course_ids = []
    for course_id in course_ids:
        if course_id not in unique_course_ids:
            unique_course_ids.append(course_id)

    if unique_course_ids:
        payload = [
            {"nyu_email": nyu_email, "course_id": int(course_id)}
            for course_id in unique_course_ids
        ]
        supabase.table("student_course").insert(payload).execute()


def replace_available_times(nyu_email, available_times):
    (
        supabase.table("student_available_time")
        .delete()
        .eq("nyu_email", nyu_email)
        .execute()
    )

    if not available_times:
        return

    next_time_id = get_next_time_id()
    payload = []
    for slot in available_times:
        payload.append(
            {
                "time_id": next_time_id,
                "week_day": int(slot["week_day"]),
                "nyu_email": nyu_email,
                "start_time": slot["start_time"],
                "end_time": slot["end_time"],
            }
        )
        next_time_id += 1

    supabase.table("student_available_time").insert(payload).execute()
