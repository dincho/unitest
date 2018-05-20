CREATE TYPE AssessmentAnswerType AS TABLE (
    assessment_id INT,
    question_id INT,
    answer_id INT,
    modifier INT
)
GO

CREATE PROC UpdateAssessmentCorrectAnswers(
    @answer_table AS AssessmentAnswerType READONLY
) AS
BEGIN
    SET NOCOUNT ON

    DECLARE @assessment_id int, @correct_answers int;

    DECLARE ass_answer_cursor CURSOR FOR
    SELECT assan.assessment_id,
        SUM(CAST(ans.correct AS INT) * assan.modifier) AS correct_answers
        FROM @answer_table assan
            LEFT JOIN questions q ON (assan.question_id = q.id)
            LEFT JOIN answers ans ON (assan.answer_id = ans.id)
        GROUP BY assan.assessment_id
     
    OPEN ass_answer_cursor
    FETCH NEXT FROM ass_answer_cursor
    INTO @assessment_id, @correct_answers

    WHILE @@FETCH_STATUS = 0  
    BEGIN
        UPDATE ass SET ass.correct_answers = ass.correct_answers + @correct_answers
            FROM assessments ass
            WHERE ass.id = @assessment_id

        FETCH NEXT FROM ass_answer_cursor
        INTO @assessment_id, @correct_answers
    END   
    CLOSE ass_answer_cursor
    DEALLOCATE ass_answer_cursor
END
GO

CREATE TRIGGER sync_assessment_answer ON assessment_answer FOR INSERT, DELETE, UPDATE
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @Answers AssessmentAnswerType
    INSERT INTO @Answers
        SELECT assessment_id, question_id, answer_id, -1 FROM DELETED
    INSERT INTO @Answers
        SELECT assessment_id, question_id, answer_id, 1 FROM INSERTED
    EXEC UpdateAssessmentCorrectAnswers @Answers
END
GO

CREATE PROC FindAssessment(
    @faculty_number VARCHAR(10) = '_',
    @discipline VARCHAR(100) = '_'
) AS
BEGIN
    SET NOCOUNT ON
    SELECT s.name 'Student name', s.faculty_number 'Fac. #',
        d.name 'Discipline', t.name 'Test', ass.taken_at 'Date taken'
        FROM assessments ass
            LEFT JOIN students s ON (ass.student_fn = s.faculty_number)
            LEFT JOIN tests t ON (ass.test_id = t.id)
            LEFT JOIN disciplines d ON (t.discipline_id = d.id)
        WHERE 
            s.faculty_number LIKE @faculty_number + '%'
            AND d.name LIKE @discipline + '%'
        ORDER BY ass.taken_at DESC
END
GO

CREATE PROC NumberOfFailedAssessments AS
BEGIN
    SET NOCOUNT ON
    SELECT COUNT(*) failed_assessments 
        FROM success_rate_view WHERE success_rate < 50
END
GO

