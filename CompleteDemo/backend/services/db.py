from supabase import Client, create_client

from config import SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY, SUPABASE_URL

# Service-role client — bypasses RLS; used for auth operations (login, signup)
# that happen before the user has a token
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)


def get_authed_client(token: str) -> Client:
    """Returns a Supabase client that forwards the user's JWT on every request.
    Uses the anon key so RLS is active; the JWT tells Supabase who the user is,
    making auth.jwt() ->> 'nyu_email' available in policies.
    """
    client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
    client.postgrest.auth(token)
    return client
