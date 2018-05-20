CREATE VIEW correct_answers_agg_view WITH SCHEMABINDING AS
SELECT q.test_id, q.variant_number, q.question_number,
    SUM(CAST(ans.correct AS INT)) AS correct_answers,
    COUNT_BIG(*) AS COUNT
    FROM dbo.assessment_answer assan
        INNER JOIN dbo.questions q ON (assan.question_id = q.id)
        INNER JOIN dbo.answers ans ON (assan.answer_id = ans.id)
    GROUP BY q.test_id, q.variant_number, q.question_number
GO

CREATE UNIQUE CLUSTERED INDEX agg_idx
    ON correct_answers_agg_view (test_id, variant_number, question_number)
GO


CREATE VIEW success_rate_view WITH SCHEMABINDING AS
SELECT ass.id ass_id, ass.correct_answers, t.max_questions,
    ROUND((ass.correct_answers/CAST(t.max_questions AS FLOAT))*100, 0) "success_rate"
    FROM dbo.assessments ass
        INNER JOIN dbo.tests t ON (ass.test_id = t.id)
GO

CREATE UNIQUE CLUSTERED INDEX ass_idx
    ON success_rate_view (ass_id)
GO


CREATE VIEW test_qa_view WITH SCHEMABINDING AS
SELECT t.name "Test", 
    q.variant_number 'Variant', q.question_number '#', q.title 'Question',
    a.title 'Answer', a.correct
    FROM dbo.tests t
        LEFT JOIN dbo.questions q ON (q.test_id = t.id)
        CROSS JOIN dbo.answers a
    WHERE a.question_id = q.id
GO


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
