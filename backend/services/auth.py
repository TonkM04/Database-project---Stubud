import hashlib
from datetime import datetime, timedelta, timezone
from functools import wraps

import bcrypt
import jwt
from flask import request

from config import JWT_ALGORITHM, JWT_SECRET
from services.responses import error_response


def build_token(student):
    payload = {
        "nyu_email": student["nyu_email"],
        "account_role": student["account_role"],
        "exp": datetime.now(timezone.utc) + timedelta(days=7),
    }
    return jwt.encode(payload, JWT_SECRET, algorithm=JWT_ALGORITHM)


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
            payload = jwt.decode(token, JWT_SECRET, algorithms=[JWT_ALGORITHM])
        except jwt.ExpiredSignatureError:
            return error_response("Token has expired", 401)
        except jwt.InvalidTokenError:
            return error_response("Invalid token", 401)

        request.user_email = payload["nyu_email"]
        request.user_role = payload["account_role"]
        return fn(*args, **kwargs)

    return wrapper
