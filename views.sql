-- Requirement 3, Query #3 - helper view
CREATE VIEW tests_agg_view WITH SCHEMABINDING AS
SELECT t.id, COUNT(q.id) num_questions,
    COUNT(DISTINCT q.variant_number) num_variants
    FROM dbo.tests t
        INNER JOIN dbo.questions q ON (t.id = q.test_id)
    GROUP BY t.id
GO

-- Requirement 3, Query #3 - also see SP NumberOfFailedAssessments
CREATE VIEW success_rate_view AS
SELECT ass.test_id, ass.student_fn, ass.correct_answers,
    ROUND((ass.correct_answers/CAST(ta.num_questions AS FLOAT))*100, 0) "success_rate"
    FROM dbo.assessments ass
        LEFT JOIN tests_agg_view ta ON ass.test_id = ta.id
GO

-- Debug view listing all tests with their question and answers
CREATE VIEW test_qa_view WITH SCHEMABINDING AS
SELECT t.name "Test", 
    q.variant_number 'Variant', q.question_number '#', q.title 'Question',
    a.title 'Answer', a.correct
    FROM dbo.tests t
        LEFT JOIN dbo.questions q ON (q.test_id = t.id)
        CROSS JOIN dbo.answers a
    WHERE a.question_id = q.id
GO

-- Debug view listing all taken assessments
CREATE VIEW student_answers_view WITH SCHEMABINDING AS
SELECT s.name "Student", t.name "Test", 
    q.variant_number 'Variant', q.question_number '#', q.title 'Question',
    ans.title 'Answer', ans.correct
    FROM dbo.assessment_answer assan
        LEFT JOIN dbo.assessments ass ON (assan.assessment_id = ass.id)
        LEFT JOIN dbo.questions q ON (assan.question_id = q.id)
        LEFT JOIN dbo.answers ans ON (assan.answer_id = ans.id)
        LEFT JOIN dbo.students s ON (ass.student_fn = s.faculty_number)
        LEFT JOIN dbo.tests t ON (ass.test_id = t.id)
GO

-- Requirement 3, Query #2
CREATE VIEW disciplines_agg_view WITH SCHEMABINDING AS
SELECT d.name, AVG(ta.num_questions) avg_questions, AVG(ta.num_variants) avg_variants
    FROM dbo.disciplines d
        INNER JOIN dbo.tests t ON t.discipline_id = d.id
        INNER JOIN dbo.tests_agg_view ta ON t.id = ta.id
    GROUP BY d.id, d.name
GO

-- Requirement 3, Query #1 - helper view
CREATE VIEW correct_answers_view WITH SCHEMABINDING AS
SELECT t.id test_id, q.variant_number, q.id question_id,
    SUM(CAST(correct as INT)) correct_answers
    FROM dbo.assessment_answer assan
        LEFT JOIN dbo.assessments ass ON (assan.assessment_id = ass.id)
        LEFT JOIN dbo.questions q ON (assan.question_id = q.id)
        LEFT JOIN dbo.answers ans ON (assan.answer_id = ans.id)
        LEFT JOIN dbo.tests t ON (ass.test_id = t.id)
    GROUP BY t.id, q.variant_number, q.id
GO

-- Requirement 3, Query #1
CREATE VIEW avg_correct_answers_view WITH SCHEMABINDING AS
SELECT t.name 'Test', q.variant_number 'Variant', q.title 'Question',
    AVG(av.correct_answers) avg_correct_answers
    FROM dbo.correct_answers_view av
        LEFT JOIN dbo.tests t ON (av.test_id = t.id)
        LEFT JOIN dbo.questions q ON (av.question_id = q.id)
    GROUP BY t.name, q.variant_number, q.title
GO
