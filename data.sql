USE unitest;
GO

INSERT INTO specialties (name) VALUES 
    ('Electronics'), ('Computing'),
    ('Software and Internet technologies'), ('Navigation'),
    ('Naval architecture and marine technology'), ('Industrial management'),
    ('Social management'), ('Telecommunication and mobile technologies');

INSERT INTO teachers (name) VALUES 
    ('Associate Professor PhD Geo Kunev'),
    ('Associate Professor PhD Hristo Nenov'),
    ('Assistant Antoaneta Ivanova'),
    ('Visiting Assistant Sevdalin Todorov');


INSERT INTO disciplines (teacher_id, name, semester) VALUES 
    (1, 'Computer networks and Internet', 5),
    (1, 'Internet servers and services', 6),
    (2, 'Principles of operating systems', 5),
    (2, 'System programming', 6),
    (3, 'Synthesis and analysis of algorithms', 2),
    (3, 'Synthesis and analysis of algorithms - project', 3),
    (4, 'System programming', 6),
    (4, 'Principles of operating systems', 6),
    (4, 'Cryptographyand data protection', 8);

INSERT INTO students (faculty_number, specialty_id, name, course, email) VALUES 
    ('111082', 1, 'Ivan Petrov', 1, 'ivan.petrov@gmail.com'),
    ('111083', 1, 'Gabriela Geneva', 1, 'gabi@gmail.com'),
    ('101012', 1, 'Misho Nedelchev', 2, 'mishka@gmail.com'),
    ('102031', 2, 'Naiden Kolev', 3, 'nacho@gmail.com'),
    ('103016', 3, 'Nina Vladigerova', 1, NULL),
    ('103039', 3, 'Asen Mitev', 1, 'asoto@gmail.com'),
    ('103056', 3, 'Lubica Marcheva', 2, 'lubka@gmail.com');

INSERT INTO tests (discipline_id, name, max_questions, max_variants) VALUES
    (1, 'SQL Quiz', 6, 2),
    (2, 'HTML Quiz', 5, 1);

INSERT INTO questions (test_id, question_number, variant_number, title) VALUES 
    (1, 1, 1, 'What does SQL stand for?'),
    (1, 2, 1, 'Which SQL statement is used to extract data from a database?'),
    (1, 3, 1, 'Which SQL statement is used to update data in a database?'),

    (1, 1, 2, 'Which SQL statement is used to delete data from a database?'),
    (1, 2, 2, 'Which SQL statement is used to insert new data in a database?'),
    (1, 3, 2, 'With SQL, how do you select a column named "FirstName" from a table named "Persons"?'),

    (2, 1, 1, 'What does HTML stand for?'),
    (2, 2, 1, 'Who is making the Web standards?'),
    (2, 3, 1, 'Choose the correct HTML element for the largest heading:'),
    (2, 4, 1, 'What is the correct HTML element for inserting a line break?'),
    (2, 5, 1, 'Choose the correct HTML element to define important text');

INSERT INTO answers (question_id, title, correct) VALUES 
    (1, 'Strong Question Language', 0),
    (1, 'Structured Question Language', 0),
    (1, 'Structured Query Language', 1),

    (2, 'SELECT', 1),
    (2, 'GET', 0),
    (2, 'EXTRACT', 0),
    (2, 'OPEN', 0),

    (3, 'UPDATE', 1),
    (3, 'SAVE', 0),
    (3, 'MODIFY', 0),
    (3, 'SAVE AS', 0),

    (4, 'COLLAPSE', 0),
    (4, 'REMOVE', 0),
    (4, 'DELETE', 1),

    (5, 'ADD RECORD', 0),
    (5, 'ADD NEW', 0),
    (5, 'INSERT INTO', 1),
    (5, 'INSERT NEW', 0),

    (6, 'EXTRACT FirstName FROM Persons', 0),
    (6, 'SELECT Persons.FirstName', 0),
    (6, 'SELECT FirstName FROM Persons', 1),

    (7, 'Hyperlinks and Text Markup Language', 0),
    (7, 'Home Tool Markup Language', 0),
    (7, 'Hyper Text Markup Language', 1),
    (7, 'The World Wide Web Consortium', 1),

    (8, 'Microsoft', 0),
    (8, 'Google', 0),
    (8, 'Mozilla', 0),

    (9, '<heading>', 0),
    (9, '<head>', 0),
    (9, '<h6>', 0),
    (9, '<h1>', 1),

    (10, '<break>', 0),
    (10, '<lb>', 0),
    (10, '<br>', 1),

    (11, '<important>', 0),
    (11, '<b>', 0),
    (11, '<i>', 0),
    (11, '<strong>', 1);

INSERT INTO assessments (student_fn, test_id, taken_at) VALUES 
    ('111082', 1, '2018-04-20 8:44'),
    ('111083', 1, '2018-04-20 8:20'),
    ('111082', 1, '2018-04-21 8:12'),
    ('111082', 2, '2018-04-22 8:05'),
    ('101012', 2, '2018-04-22 8:01');

INSERT INTO assessment_answer (assessment_id, question_id, answer_id) VALUES 
    (1, 1, 1),
    (1, 2, 4),
    (1, 3, 8),

    (2, 1, 2),
    (2, 2, 5),
    (2, 3, 8),

    (3, 4, 12),
    (3, 5, 17),
    (3, 6, 21)

    ;

GO
