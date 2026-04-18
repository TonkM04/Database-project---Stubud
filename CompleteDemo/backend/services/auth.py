import hashlib
from datetime import datetime, timedelta, timezone
from functools import wraps

import bcrypt
import jwt
from flask import g, request

from config import SUPABASE_JWT_SECRET
from services.responses import error_response

_ALGORITHM = "HS256"


def build_token(student):
    now = datetime.now(timezone.utc)
    payload = {
        # Supabase-required claims — these make Supabase assign the "authenticated" role
        "sub": student["nyu_email"],
        "role": "authenticated",
        "aud": "authenticated",
        "iss": "supabase",
        "iat": now,
        "exp": now + timedelta(days=7),
        # Custom claims — readable by Flask and by RLS policies via auth.jwt()
        "nyu_email": student["nyu_email"],
        "account_role": student["account_role"],
    }
    return jwt.encode(payload, SUPABASE_JWT_SECRET, algorithm=_ALGORITHM)


def sanitize_student(student):
    return {
        "nyu_email": student["nyu_email"],
        "first_name": student["first_name"],
        "last_name": student.get("last_name"),
        "account_role": student["account_role"],
    }


def verify_password(plain_password, stored_password):
    if not stored_password:
        return False

    if stored_password.startswith("$2"):
        return bcrypt.checkpw(
            plain_password.encode("utf-8"),
            stored_password.encode("utf-8"),
        )

    legacy_hash = hashlib.md5(plain_password.encode("utf-8")).hexdigest()
    return legacy_hash == stored_password


def hash_password(password):
    return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")


def get_bearer_token():
    auth_header = request.headers.get("Authorization", "")
    if not auth_header.startswith("Bearer "):
        return None
    return auth_header.split(" ", 1)[1].strip()


def require_auth(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        token = get_bearer_token()
        if not token:
            return error_response("Missing bearer token", 401)

        try:
            payload = jwt.decode(
                token,
                SUPABASE_JWT_SECRET,
                algorithms=[_ALGORITHM],
                audience="authenticated",
            )
        except jwt.ExpiredSignatureError:
            return error_response("Token has expired", 401)
        except jwt.InvalidTokenError:
            return error_response("Invalid token", 401)

        request.user_email = payload["nyu_email"]
        request.user_role = payload["account_role"]

        # Attach a user-scoped Supabase client so every DB call in this request
        # carries the JWT — this is what makes Supabase RLS enforce the user's identity
        from services.db import get_authed_client
        g.db = get_authed_client(token)

        return fn(*args, **kwargs)

    return wrapper
