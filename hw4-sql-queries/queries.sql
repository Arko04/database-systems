-- Alireza Karimi
-- 810101492
-- 1
SELECT S.FirstName, S.LastName
FROM Student S, Enrollment E, Course C
WHERE S.studentID = E.studentID 
  AND E.CourseID = C.CourseID 
  AND C.CourseName = 'Introduction to Programming';
  
-- 2
SELECT P.FirstName, P.LastName
FROM Professor P, Teaches T, Course C
WHERE P.ProfessorID = T.ProfessorID
  AND C.CourseID = T.CourseID
  AND C.CourseName = 'Data Structures and Algorithms';

-- 3
SELECT 
    S.FirstName, 
    S.LastName,
    ExamCounts.ExamCount
FROM 
    Student S,
    (SELECT StudentID, COUNT(*) AS ExamCount
     FROM ExamResult
     GROUP BY StudentID) AS ExamCounts
WHERE 
    S.StudentID = ExamCounts.StudentID
  AND ExamCounts.ExamCount = (
      SELECT MAX(ExamCount)
      FROM (
          SELECT COUNT(*) AS ExamCount
          FROM ExamResult
          GROUP BY StudentID
      ) AS Counts
  );

-- 4
SELECT DepartmentName, CourseCount
FROM Department D,
    (SELECT DepartmentID, COUNT(*) AS CourseCount
     FROM Course
     GROUP BY DepartmentID) C
WHERE D.DepartmentID = C.DepartmentID
  AND CourseCount = (
    SELECT MAX(Cnt)
    FROM (
      SELECT COUNT(*) AS Cnt
      FROM Course
      GROUP BY DepartmentID
    ) AS T
  );
  
-- 5
SELECT DISTINCT S.FirstName, S.LastName
FROM Student S, DormAssignment DA, BookLoan B1, BookLoan B2
WHERE S.StudentID = DA.StudentID 
  AND S.StudentID = B1.StudentID
  AND S.StudentID = B2.StudentID
  AND B1.BookID <> B2.BookID;

-- 6
SELECT DISTINCT C.CourseName
FROM Course C, Prerequisite P1, Prerequisite P2
WHERE C.CourseID = P1.CourseID
  AND C.CourseID = P2.CourseID
  AND P1.PrerequisiteCourseID <> P2.PrerequisiteCourseID;
  
-- 7
SELECT AVG(CourseCount) AS AvgCoursesPerStudent
FROM (
  SELECT StudentID, COUNT(*) AS CourseCount
  FROM Enrollment
  GROUP BY StudentID
) AS T;

-- 8
SELECT FirstName, LastName,
  (SELECT COUNT(*) FROM BookLoan BL WHERE BL.StudentID = S.StudentID) AS LoanCount
FROM Student S
WHERE StudentID IN (
  SELECT StudentID
  FROM BookLoan
  GROUP BY StudentID
  HAVING COUNT(*) = (
    SELECT MAX(Cnt)
    FROM (
      SELECT COUNT(*) AS Cnt
      FROM BookLoan
      GROUP BY StudentID
    ) AS T
  )
);

-- 9
SELECT FirstName, LastName,
  (SELECT COUNT(*) FROM Teaches T WHERE T.ProfessorID = P.ProfessorID) AS CourseCount
FROM Professor P
WHERE ProfessorID IN (
  SELECT ProfessorID
  FROM Teaches
  GROUP BY ProfessorID
  HAVING COUNT(*) = (
    SELECT MAX(Cnt)
    FROM (
      SELECT COUNT(*) AS Cnt
      FROM Teaches
      GROUP BY ProfessorID
    ) AS T
  )
);

-- 10
SELECT DISTINCT S.FirstName, S.LastName, D.DormName
FROM Student S, DormAssignment DA, Dormitory D,
     BookLoan B1, BookLoan B2,
     StudentActivity SA,
     Enrollment C1, Enrollment C2
WHERE S.StudentID = DA.StudentID
  AND DA.DormID = D.DormID
  AND S.StudentID = B1.StudentID
  AND S.StudentID = B2.StudentID
  AND B1.LoanID <> B2.LoanID
  AND S.StudentID = SA.StudentID
  AND S.StudentID = C1.StudentID
  AND S.StudentID = C2.StudentID
  AND C1.CourseID <> C2.CourseID;
  
-- 11
SELECT 
    S.FirstName,
    S.LastName,
    A.AvgScore AS AverageScore
FROM Student S
JOIN (
    SELECT StudentID, AVG(Score) AS AvgScore
    FROM ExamResult
    GROUP BY StudentID
) A ON S.StudentID = A.StudentID
WHERE A.AvgScore = (
    SELECT MAX(AvgScore)
    FROM (
        SELECT AVG(Score) AS AvgScore
        FROM ExamResult
        GROUP BY StudentID
    ) AS AvgScores
);

-- 12
DROP VIEW IF EXISTS studentaveragescores;
CREATE VIEW StudentAverageScores AS
SELECT S.FirstName, S.LastName, AVG(E.Score) AS AverageScore
FROM Student S, ExamResult E
WHERE S.StudentID = E.StudentID
GROUP BY S.StudentID;

-- 13
DROP VIEW IF EXISTS StudentTopScores;

CREATE VIEW StudentTopScores AS
SELECT 
  S.FirstName,
  S.LastName,
  C.CourseName,
  ER.Score
FROM 
  Student S
JOIN ExamResult ER ON S.StudentID = ER.StudentID
JOIN Exam E ON ER.ExamID = E.ExamID
JOIN Course C ON E.CourseID = C.CourseID
WHERE 
  ER.Score = (
    SELECT MAX(ER2.Score)
    FROM ExamResult ER2
    WHERE ER2.StudentID = S.StudentID
  );

-- 14
DROP VIEW IF EXISTS ActiveProfessors;
CREATE VIEW ActiveProfessors AS
SELECT 
  P.FirstName,
  P.LastName,
  D.DepartmentName,
  (SELECT COUNT(*) 
   FROM Teaches T 
   WHERE T.ProfessorID = P.ProfessorID) AS CourseCount
FROM 
  Professor P, Department D
WHERE 
  P.DepartmentID = D.DepartmentID
  AND (
    SELECT COUNT(*) 
    FROM Teaches T 
    WHERE T.ProfessorID = P.ProfessorID
  ) > (
    SELECT AVG(Cnt)
    FROM (
      SELECT COUNT(*) AS Cnt
      FROM Teaches
      GROUP BY ProfessorID
    ) AS T
  );

-- 15
DELIMITER //

CREATE TRIGGER CheckScoreLimit
BEFORE INSERT ON ExamResult
FOR EACH ROW
BEGIN
  IF NEW.Score > 100 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Score cannot exceed 100';
  END IF;
END //

DELIMITER ;

-- 16
DELIMITER //

CREATE TRIGGER CheckEmailNotEmpty
BEFORE UPDATE ON Student
FOR EACH ROW
BEGIN
  IF NEW.Email IS NULL OR NEW.Email = '' THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Email cannot be empty';
  END IF;
END //

DELIMITER ;
-- 17
DELIMITER //

CREATE TRIGGER CheckDormCapacity
BEFORE INSERT ON DormAssignment
FOR EACH ROW
BEGIN
  DECLARE AssignedCount INT;

  SELECT COUNT(*) INTO AssignedCount
  FROM DormAssignment
  WHERE DormID = NEW.DormID;

  IF AssignedCount >= (
      SELECT Capacity FROM Dormitory WHERE DormID = NEW.DormID
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Dormitory capacity exceeded';
  END IF;
END //

DELIMITER ;
