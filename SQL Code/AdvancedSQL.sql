/*
This files contain the advanced SQL Commands.
*/

--Student Pages SQL
--Trigger for updating or number of students in a meeting

DELIMITER //
DROP TRIGGER IF EXISTS update_num_of_students_on_meeting;
CREATE TRIGGER update_num_of_students_on_meeting
AFTER INSERT ON Meeting_Request
FOR EACH ROW
BEGIN
    UPDATE Meeting
    SET num_of_students = num_of_students + 1
    WHERE meeting_id = NEW.meeting_id;
END//
DELIMITER ;

--Trigger that performs cleanup after student account is deleted.
DELIMITER //
DROP TRIGGER IF EXISTS cleanup_after_deleting_student
AFTER DELETE ON Student
FOR EACH ROW
BEGIN
    DELETE FROM Student_Available_Time
    WHERE NYU_Email = OLD.NYU_Email;

    DELETE FROM Student_Course
    WHERE NYU_Email = OLD.NYU_Email;
END//
DELIMITER ;

--Trigger that performs cleanup after meeting is deleted by the admin.
DELIMITER //
DROP TRIGGER IF EXISTS cleanup_after_deleting_meeting
AFTER DELETE ON Meeting
FOR EACH ROW
BEGIN
    DELETE FROM Meeting_Request
    WHERE Meeting_ID = OLD.Meeting_ID;

    DELETE FROM Study_Material
    WHERE Meeting_ID = OLD.Meeting_ID;

    DELETE FROM Feedback
    WHERE Meeting_ID = OLD.Meeting_ID;

    DELETE FROM Invitation
    WHERE Meeting_ID = OLD.Meeting_ID;
END//
DELIMITER ;

--Procedure that joins a group but with validation check

DELIMITER //
DROP PROCEDURE IF EXISTS join_group;
CREATE PROCEDURE join_group(in meeting_id INT, in nyu_email VARCHAR(255), out result VARCHAR(255))
BEGIN
    DECLARE location_capacity INT;
    DECLARE current_num_of_students INT;

    --First find the capacity for the location of the meeting
    SELECT L.Capacity INTO location_capacity
    FROM Location L
    INNER JOIN Meeting M 
    ON L.Location_ID = M.Location_ID
    WHERE M.Meeting_ID = meeting_id;

    --Then find the current number of students in the meeting
    SELECT Num_Of_Students INTO current_num_of_students
    FROM Meeting
    WHERE Meeting_ID = meeting_id;

    --Check if the meeting is full
    IF current_num_of_students + 1 <= location_capacity THEN
        --If the meeting is not full, then insert 
        INSERT INTO Meeting_Request (Meeting_ID, NYU_Email)
        VALUES (meeting_id, nyu_email);

        SET result = 'Successfully joined the group.';
    ELSE
        --If the meeting is full, then return failure message.
        SET result = 'Error, the group is already full.';
    END IF;
END //
DELIMITER ;

--Admin Page SQL
--Well, I thought about it and I think it would be beneficial to add a bunch of
--SQL functions for added functionality. We may or may not use all of these for our website
--But is it nice to have the variety and they will be here is we need them. 

--Function that get average rating for a meeting
DELIMITER //
DROP FUNCTION IF EXISTS get_average_rating;
CREATE FUNCTION get_average_rating(meeting_id INT) RETURNS DECIMAL(3,2) NOT DETERMINISTIC
BEGIN
    DECLARE average_rating DECIMAL(3,2);

    SELECT AVG(Rating) INTO average_rating
    FROM Feedback
    WHERE Meeting_ID = meeting_id;

    IF average_rating IS NULL THEN
        SET average_rating = 0.00;
    END IF;

    RETURN average_rating;
END //
DELIMITER ;

--Function that get how many meetings a student has joined
DELIMITER //
DROP FUNCTION IF EXISTS get_num_of_meetings_joined;
CREATE FUNCTION get_num_of_meetings_joined(nyu_email VARCHAR(255)) RETURNS INT NOT DETERMINISTIC
BEGIN
    DECLARE num_of_meetings_joined INT;

    SELECT COUNT(*) INTO num_of_meetings_joined
    FROM Meeting_Request
    WHERE NYU_Email = nyu_email;
    
    RETURN num_of_meetings_joined;
END //
DELIMITER ;

--Function that display the duration of a meeting
--Note that TIMESTAMPDIFF returns an INT so the return value of this function is also INT
DELIMITER //
DROP FUNCTION IF EXISTS get_meeting_duration;
CREATE FUNCTION get_meeting_duration(meeting_id INT) RETURNS INT NOT DETERMINISTIC
BEGIN
    DECLARE duration INT;

    SELECT TIMESTAMPDIFF(MINUTE, Start_Time, End_Time) INTO duration
    FROM Meeting
    WHERE Meeting_ID = meeting_id;

    RETURN duration;
END//
DELIMITER ;

--Function that checks whether a meeting is full
--Also can be used to check whehter a student can join a meeting
--Note that the function returns false if the meeting is not full, meaning the student can join
--and true if the meeting is full, which means the student can't join.
DELIMITER //
DROP FUNCTION IF EXISTS check_is_meeting_full;
CREATE FUNCTION check_is_meeting_full(meeting_id INT) RETURNS BOOLEAN NOT DETERMINISTIC
BEGIN
    DECLARE location_capacity INT;
    DECLARE current_num_of_students INT;

    SELECT L.Capacity INTO location_capacity
    FROM Location L
    INNER JOIN Meeting M
    ON L.Location_ID = M.Location_ID
    WHERE M.Meeting_ID = meeting_id;

    SELECT Num_Of_Students INTO current_num_of_students
    FROM Meeting
    WHERE Meeting_ID = meeting_id;

    RETURN current_num_of_students >= location_capacity;
END//
DELIMITER ;