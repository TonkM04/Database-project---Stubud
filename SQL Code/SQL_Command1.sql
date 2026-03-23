'''Login Page'''
--Check Student Login
SELECT NYU_Email, FirstName, LastName, Hashed_Password, Account_Role
FROM Student 
WHERE NYU_Email = %(NYU_Email)s;

'''Groups Page'''
--Display All Study Groups
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Course c, Location l
WHERE m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID;

'''Join Group'''
--Student joins the selected group
INSERT INTO Meeting_Request (Meeting_ID, NYU_Email)
VALUES (%(Meeting_ID)s, %(NYU_Email)s);

'''Students Page'''
--Display All Students
SELECT NYU_Email, FirstName, LastName
FROM Student 
WHERE Account_Role = 'student';

'''Dashboard'''
--Display Groups Joined By Student
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Meeting_Request mr, Course c, Location l
WHERE m.Meeting_ID = mr.Meeting_ID
AND m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID
AND mr.NYU_Email = %(NYU_Email)s;

'''Group #ID'''
--Display Meeting Details
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Course c, Location l
WHERE m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID
AND m.Meeting_ID = %(Meeting_ID)s;

--Display Students In This Group
SELECT s.NYU_Email,
s.FirstName,
s.LastName
FROM Student s, Meeting_Request mr
WHERE s.NYU_Email = mr.NYU_Email
AND mr.Meeting_ID = %(Meeting_ID)s;

'''Join Invitation Page'''
--Display Invitation Information
SELECT i.Invitation_ID,
i.Sent_Date,
m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note
FROM Invitation i, Meeting m
WHERE i.Meeting_ID = m.Meeting_ID
AND i.NYU_Email = %(NYU_Email)s;

--Accept Invitation
INSERT INTO Meeting_Request (Meeting_ID, NYU_Email)
VALUES (%(Meeting_ID)s, %(NYU_Email)s);

--Reject Invitation
DELETE 
FROM Invitation
WHERE Invitation_ID = %(Invitation_ID)s;

'''
Admin Pages SQL
'''

'''Admin Login'''
--Check Admin Login
SELECT NYU_Email, FirstName, LastName, Hashed_Password
FROM Student 
WHERE NYU_Email = %(NYU_Email)s
AND Account_Role = 'admin';

'''Admin Groups Page'''
--Display All Groups
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Course c, Location l
WHERE m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID;

'''Admin Groups Page'''
--Display All Groups
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Course c, Location l
WHERE m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID;

'''Create Group'''
--Create Location
INSERT INTO Location(Location_ID, Building, Room, Capacity) 
VALUES (%(Location_ID)s, %(Building)s, %(Room)s, %(Capacity)s);


--Create Meeting
INSERT INTO Meeting (Meeting_ID, Start_Time, End_Time, Meeting_Note, Num_Of_Students, Course_ID, Location_ID)
VALUES (%(Meeting_ID)s, %(Start_Time)s, %(End_Time)s, %(Meeting_Note)s, %(Num_Of_Students)s, %(Course_ID)s, %(Location_ID)s);

'''Admin Group Detail Page'''
--Display Group Info
SELECT m.Meeting_ID,
m.Start_Time,
m.End_Time,
m.Meeting_Note,
m.Num_Of_Students,
c.Course_Name,
l.Building,
l.Room
FROM Meeting m, Course c, Location l
WHERE m.Course_ID = c.Course_ID
AND m.Location_ID = l.Location_ID
AND m.Meeting_ID = %(Meeting_ID)s;


--Update Group Info
UPDATE Meeting
SET Start_Time = %(Start_Time)s,
End_Time = %(End_Time)s,
Meeting_Note = %(Meeting_Note)s,
Num_Of_Students = %(Num_Of_Students)s,
Course_ID = %(Course_ID)s,
Location_ID = %(Location_ID)s
WHERE Meeting_ID = %(Meeting_ID)s;

--Delete Group
DELETE 
FROM Meeting
WHERE Meeting_ID = %(Meeting_ID)s;

'''Admin Students Page'''
--Display All Students
SELECT NYU_Email, FirstName, LastName
FROM Student 
WHERE Account_Role = 'student';

'''Admin Student Profile'''
--Display Student Profile
SELECT s.NYU_Email,
s.FirstName,
s.LastName,
c.Course_Name
FROM Student s, Student_Course sc, Course c
WHERE s.NYU_Email = sc.NYU_Email
AND sc.Course_ID = c.Course_ID
AND s.NYU_Email = %(NYU_Email)s;

--Update Student Info
UPDATE Student
SET FirstName = %(FirstName)s,
LastName = %(LastName)s
WHERE NYU_Email = %(NYU_Email)s;

--Delete Student
DELETE 
FROM Student
WHERE NYU_Email = %(NYU_Email)s;

'''Admin Dashboard'''
--Count Total Groups
SELECT COUNT(Meeting_ID)
FROM Meeting;

--Count Total Students
SELECT COUNT(NYU_Email)
FROM Student 
WHERE Account_Role = 'student';