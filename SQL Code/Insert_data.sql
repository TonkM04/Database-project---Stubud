---Insert fake data for database

---Student
INSERT INTO Student (NYU_Email, First_Name, Last_Name, Hashed_Password, Account_Role) VALUES
('ab1001@nyu.edu','Liam','Stone','5f4dcc3b5aa765d61d8327deb882cf99','admin'),
('ab1002@nyu.edu','Noah','Blake','202cb962ac59075b964b07152d234b70','student'),
('ab1003@nyu.edu','Evan','Reed','098f6bcd4621d373cade4e832627b4f6','student'),
('ab1004@nyu.edu','Owen','Cole','ad0234829205b9033196ba818f7a872b','student'),
('ab1005@nyu.edu','Ryan','Dale','8ad8757baa8564dc136c1e07507f4a98','student'),
('ab1006@nyu.edu','Luke','Hart','6512bd43d9caa6e02c990b0a82652dca','student'),
('ab1007@nyu.edu','Eric','Shaw','c20ad4d76fe97759aa27a0c99bff6710','student'),
('ab1008@nyu.edu','Ivan','Cross','c51ce410c124a10e0db5e4b97fc2af39','student'),
('ab1009@nyu.edu','Milo','Frost','aab3238922bcc25a6f606eb525ffdc56','student'),
('ab1010@nyu.edu','Nico','Wade','9bf31c7ff062936a96d3c8bd1f8f2ff3','student'),
('ab1011@nyu.edu','Zane','Brooks','c74d97b01eae257e44aa9d5bade97baf','student'),
('ab1012@nyu.edu','Kyle','Nash','70efdf2ec9b086079795c442636b55fb','student'),
('ab1013@nyu.edu','Leon','Griff','6f4922f45568161a8cdf4ad2299f6d23','student'),
('ab1014@nyu.edu','Otis','Flynn','1f0e3dad99908345f7439f8ffabdffc4','student'),
('ab1015@nyu.edu','Arlo','Quinn','98f13708210194c475687be6106a3b84','student');

--Student_Available_Time
INSERT INTO Student_Available_Time (Time_ID, Week_Day, NYU_Email, Start_Time, End_Time) VALUES
(1,1,'ab1001@nyu.edu','09:00','10:00'),
(2,2,'ab1002@nyu.edu','10:00','11:00'),
(3,3,'ab1003@nyu.edu','11:00','12:00'),
(4,4,'ab1004@nyu.edu','13:00','14:00'),
(5,5,'ab1005@nyu.edu','14:00','15:00'),
(6,1,'ab1006@nyu.edu','09:00','10:00'),
(7,2,'ab1007@nyu.edu','10:00','11:00'),
(8,3,'ab1008@nyu.edu','11:00','12:00'),
(9,4,'ab1009@nyu.edu','13:00','14:00'),
(10,5,'ab1010@nyu.edu','14:00','15:00'),
(11,1,'ab1011@nyu.edu','09:00','10:00'),
(12,2,'ab1012@nyu.edu','10:00','11:00'),
(13,3,'ab1013@nyu.edu','11:00','12:00'),
(14,4,'ab1014@nyu.edu','13:00','14:00'),
(15,5,'ab1015@nyu.edu','14:00','15:00');

--Course
INSERT INTO Course (Course_ID, Course_Name) VALUES
(101,'CS-UY1114 IntroProgramming'),
(102,'CS-UY1134 DataStructures'),
(103,'CS-UY2124 ObjectOrientedProg'),
(104,'CS-UY1122 IntroComputerSci'),
(105,'CS-UY2214 CompArchitecture'),
(106,'CS-UY3224 OperatingSystems'),
(107,'CS-UY2413 AlgorithmsDesign'),
(108,'CS-UY4513 SoftwareEngineering'),
(109,'CS-UY4523 DesignProject'),
(110,'MA-UY1024 CalculusI'),
(111,'MA-UY1124 CalculusII'),
(112,'MA-UY2314 DiscreteMath'),
(113,'MA-UY2224 DataAnalysis'),
(114,'EG-UY1001 EngTechForum'),
(115,'EG-UY1003 IntroEngDesign');

--Student_Course
INSERT INTO Student_Course (NYU_Email, Course_ID) VALUES
('ab1001@nyu.edu',101),
('ab1002@nyu.edu',102),
('ab1003@nyu.edu',103),
('ab1004@nyu.edu',104),
('ab1005@nyu.edu',105),
('ab1006@nyu.edu',106),
('ab1007@nyu.edu',107),
('ab1008@nyu.edu',108),
('ab1009@nyu.edu',109),
('ab1010@nyu.edu',110),
('ab1011@nyu.edu',111),
('ab1012@nyu.edu',112),
('ab1013@nyu.edu',113),
('ab1014@nyu.edu',114),
('ab1015@nyu.edu',115);

--Location
INSERT INTO Location (Location_ID, Building, Room, Capacity) VALUES
(1,'5 Metro Tech','301',4),
(2,'5 Metro Tech','312',6),
(3,'5 Metro Tech','325',5),
(4,'5 Metro Tech','337',4),
(5,'5 Metro Tech','348',8),
(6,'5 Metro Tech','401',6),
(7,'5 Metro Tech','415',5),
(8,'5 Metro Tech','428',4),
(9,'6 Metro Tech','210',6),
(10,'6 Metro Tech','318',5),
(11,'6 Metro Tech','422',8),
(12,'6 Metro Tech','537',6),
(13,'6 Metro Tech','604',4),
(14,'6 Metro Tech','712',6),
(15,'6 Metro Tech','745',5);

---Meeting
INSERT INTO Meeting (Meeting_ID, Start_Time, End_Time, Meeting_Note, Num_Of_Students, Course_ID, Location_ID) VALUES
(1,'2026-03-20','2026-03-20','Database review',5,101,1),
(2,'2026-03-21','2026-03-21','DS homework help',4,102,2),
(3,'2026-03-22','2026-03-22','Algorithm practice',6,103,3),
(4,'2026-03-23','2026-03-23','OOP concepts',3,104,4),
(5,'2026-03-24','2026-03-24','Computer architecture discussion',5,105,5),
(6,'2026-03-25','2026-03-25','Operating systems review',4,106,1),
(7,'2026-03-26','2026-03-26','Software engineering meeting',5,107,2),
(8,'2026-03-27','2026-03-27','AI study group',6,108,3),
(9,'2026-03-28','2026-03-28','Machine learning basics',4,109,4),
(10,'2026-03-29','2026-03-29','Cyber security intro',5,110,5),
(11,'2026-03-30','2026-03-30','Distributed systems talk',4,111,1),
(12,'2026-03-31','2026-03-31','Cloud computing notes',6,112,2),
(13,'2026-04-01','2026-04-01','Data mining examples',5,113,3),
(14,'2026-04-02','2026-04-02','HCI design discussion',4,114,4),
(15,'2026-04-03','2026-04-03','Graphics programming help',5,115,5);

--Invitation
INSERT INTO Invitation (Invitation_ID, Sent_Date, Meeting_ID, NYU_Email) VALUES
(1,'2026-03-15',1,'ab1002@nyu.edu'),
(2,'2026-03-15',2,'ab1003@nyu.edu'),
(3,'2026-03-15',3,'ab1004@nyu.edu'),
(4,'2026-03-16',4,'ab1005@nyu.edu'),
(5,'2026-03-16',5,'ab1006@nyu.edu'),
(6,'2026-03-16',6,'ab1007@nyu.edu'),
(7,'2026-03-17',7,'ab1008@nyu.edu'),
(8,'2026-03-17',8,'ab1009@nyu.edu'),
(9,'2026-03-17',9,'ab1010@nyu.edu'),
(10,'2026-03-18',10,'ab1011@nyu.edu'),
(11,'2026-03-18',11,'ab1012@nyu.edu'),
(12,'2026-03-18',12,'ab1013@nyu.edu'),
(13,'2026-03-19',13,'ab1014@nyu.edu'),
(14,'2026-03-19',14,'ab1015@nyu.edu'),
(15,'2026-03-19',15,'ab1001@nyu.edu');

--Feedback
INSERT INTO Feedback (NYU_Email, Meeting_ID, Rating, Comment) VALUES
('ab1002@nyu.edu',1,5,'Very helpful session'),
('ab1003@nyu.edu',2,4,NULL),
('ab1004@nyu.edu',3,5,'Clear explanations'),
('ab1005@nyu.edu',4,3,NULL),
('ab1006@nyu.edu',5,4,'Good discussion'),
('ab1007@nyu.edu',6,5,NULL),
('ab1008@nyu.edu',7,4,'Helpful notes'),
('ab1009@nyu.edu',8,5,NULL),
('ab1010@nyu.edu',9,4,'Useful examples'),
('ab1011@nyu.edu',10,5,NULL),
('ab1012@nyu.edu',11,3,'Average meeting'),
('ab1013@nyu.edu',12,4,NULL),
('ab1014@nyu.edu',13,5,'Great study group'),
('ab1015@nyu.edu',14,4,NULL),
('ab1001@nyu.edu',15,5,'Very productive');

--Meeting_Request
INSERT INTO Meeting_Request (Meeting_ID, NYU_Email) VALUES
(1,'ab1003@nyu.edu'),
(2,'ab1004@nyu.edu'),
(3,'ab1005@nyu.edu'),
(4,'ab1006@nyu.edu'),
(5,'ab1007@nyu.edu'),
(6,'ab1008@nyu.edu'),
(7,'ab1009@nyu.edu'),
(8,'ab1010@nyu.edu'),
(9,'ab1011@nyu.edu'),
(10,'ab1012@nyu.edu'),
(11,'ab1013@nyu.edu'),
(12,'ab1014@nyu.edu'),
(13,'ab1015@nyu.edu'),
(14,'ab1001@nyu.edu'),
(15,'ab1002@nyu.edu');

--Study_Material
INSERT INTO Study_Material (Study_Material_ID, File_Name, File_Path, Meeting_ID) VALUES
(1,'db_notes.pdf','/materials/db_notes.pdf',1),
(2,'ds_slides.pdf','/materials/ds_slides.pdf',2),
(3,'algo_examples.pdf','/materials/algo_examples.pdf',3),
(4,'oop_summary.pdf','/materials/oop_summary.pdf',4),
(5,'arch_review.pdf','/materials/arch_review.pdf',5),
(6,'os_notes.pdf','/materials/os_notes.pdf',6),
(7,'se_design.pdf','/materials/se_design.pdf',7),
(8,'ai_intro.pdf','/materials/ai_intro.pdf',8),
(9,'ml_basics.pdf','/materials/ml_basics.pdf',9),
(10,'security_notes.pdf','/materials/security_notes.pdf',10),
(11,'dist_systems.pdf','/materials/dist_systems.pdf',11),
(12,'cloud_notes.pdf','/materials/cloud_notes.pdf',12),
(13,'data_mining.pdf','/materials/data_mining.pdf',13),
(14,'hci_design.pdf','/materials/hci_design.pdf',14),
(15,'graphics_notes.pdf','/materials/graphics_notes.pdf',15);

