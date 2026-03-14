'''
Note that everything is written as Named Placeholders
You can just copy and paste and plugin the values using Python Flask
'''

--This sql is for the second column from the UI. 
--Check the UI when coding for the website so that you know which sql is for which
--The order is simply top to down

'''StuBud'''
--Signup Page: Create Student Account
INSERT INTO Student (NYU_Email, FirstName, LastName, Email, Hashed_Password, Account_Role) --Remeber to calculate hash before plugin the value
Values (%(NYU_Email)s, %(FirstName)s, %(LastName)s, %(Email)s, %(Hashed_Password)s, %(Account_Role)s); --Account_Role can be default to "student". The admin account should be manually added. 

'''Create New Meeting''' 
--Create New Meeting
INSERT INTO Meeting (Meeting_ID, Start_Time, End_Time, Meeting_Note, Num_Of_Students, Course_ID, Location_ID) 
Values (%(Meeting_ID)s, %(Start_Time)s, %(End_Time)s, %(Meeting_Note)s, %(Num_Of_Students)s, %(Course_ID)s, %(Location_ID)s);

'''Student Info'''
--Display Student Info
SELECT First_Name, Last_Name, NYU_Email, Course_Name --There are going to multiple courses so you may need to use python for loop to iterate through courses
FROM Student 
INNER JOIN Student_Course ON Student.NYU_Email = Student_Course.NYU_Email
INNER JOIN Course ON Student_Course.Course_ID = Course.Course_ID
WHERE NYU_Email = %(NYU_Email)s;

'''Profile'''
--Update Student Profile
--Part 1: Basic Info
UPDATE Student
SET First_Name = %(First_Name)s, Last_Name = %(Last_Name)s, Hashed_Password = %(Hashed_Password)s
WHERE NYU_Email = %(NYU_Email)s;

--Part 2: Available Time
--First delete the old available time and then insert the new available time.
DELETE FROM Student_Available_Time
WHERE NYU_Email = %(NYU_Email)s;    

--Again, you may need to loop this to add multiple available time for the student.
INSERT INTO Student_Available_Time (Time_ID, Week_Day, Start_Time, End_Time, NYU_Email)
Values (%(Time_ID)s, %(Week_Day)s, %(Start_Time)s, %(End_Time)s, %(NYU_Email)s);

--Part 3: Courses Taken
--First delete the old courses and then insert the new courses.
DELETE FROM Student_Course
WHERE NYU_Email = %(NYU_Email)s AND 
Course_ID IN %(Course_ID)s; --This is a list of course id that the student wants to drop. 

--Again, you may need to loop this to add multiple courses for the student.
INSERT INTO Student_Course (NYU_Email, Course_ID)
Values (%(NYU_Email)s, %(Course_ID)s); --This is a list of course id that the student wants to add.

'''Study Materials'''
SELECT File_Name, File_Path
From Study Material
WHERE Meeting_ID = %(Meeting_ID)s; 
--This is the Meeting id for the Meeting that the study material come from. 

'''Successfully Joined'''
SELECT Meeting_ID, Start_Time, End_Time, Meeting_Note, Num_Of_Students, Course_Name, Location_Name
FROM Meeting
INNER JOIN Course ON Meeting.Course_ID = Course.Course_ID
INNER JOIN Location ON Meeting.Location_ID = Location.Location_ID
WHERE Meeting_ID IN %(Meeting_ID)s; --This is the Meeting id that the student has successfully joined. 






