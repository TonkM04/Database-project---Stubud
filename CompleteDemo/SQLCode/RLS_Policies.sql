-- =============================================================
-- RLS Policies for StuBud
-- Run in: Supabase Dashboard → SQL Editor → New Query
-- =============================================================
-- Identity check used in policies:
--   auth.jwt() ->> 'nyu_email'  reads the custom claim from the
--   Flask-generated JWT to identify the current user.
-- =============================================================


-- -------------------------------------------------------------
-- STEP 1: Enable RLS on all tables
-- -------------------------------------------------------------
ALTER TABLE student                ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_available_time ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_course         ENABLE ROW LEVEL SECURITY;
ALTER TABLE course                 ENABLE ROW LEVEL SECURITY;
ALTER TABLE location               ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting                ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_request        ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedback               ENABLE ROW LEVEL SECURITY;
ALTER TABLE invitation             ENABLE ROW LEVEL SECURITY;
ALTER TABLE study_material         ENABLE ROW LEVEL SECURITY;


-- -------------------------------------------------------------
-- STEP 2: Allow SELECT (read) on every table
--         Both anon and authenticated users can read all data
-- -------------------------------------------------------------
CREATE POLICY "read all"  ON student                FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON student_available_time FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON student_course         FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON course                 FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON location               FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON meeting                FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON meeting_request        FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON feedback               FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON invitation             FOR SELECT TO anon, authenticated USING (true);
CREATE POLICY "read all"  ON study_material         FOR SELECT TO anon, authenticated USING (true);


-- -------------------------------------------------------------
-- STEP 3: Allow INSERT of own records on the 5 write tables
--         nyu_email in the new row must match the JWT identity
-- -------------------------------------------------------------
CREATE POLICY "insert own record"
  ON feedback FOR INSERT TO authenticated
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "insert own record"
  ON invitation FOR INSERT TO authenticated
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "insert own record"
  ON meeting_request FOR INSERT TO authenticated
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "insert own record"
  ON student_available_time FOR INSERT TO authenticated
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

-- study_material has no nyu_email column; any authenticated user can insert
CREATE POLICY "insert own record"
  ON study_material FOR INSERT TO authenticated
  WITH CHECK (true);


-- -------------------------------------------------------------
-- STEP 4: Extra write policies required by the app's profile
--         update flow (replace_courses / replace_available_times
--         delete then re-insert rows)
-- -------------------------------------------------------------
CREATE POLICY "update own row"
  ON student FOR UPDATE TO authenticated
  USING  (nyu_email = auth.jwt() ->> 'nyu_email')
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "delete own rows"
  ON student_available_time FOR DELETE TO authenticated
  USING (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "insert own rows"
  ON student_course FOR INSERT TO authenticated
  WITH CHECK (nyu_email = auth.jwt() ->> 'nyu_email');

CREATE POLICY "delete own rows"
  ON student_course FOR DELETE TO authenticated
  USING (nyu_email = auth.jwt() ->> 'nyu_email');
