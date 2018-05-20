CREATE DATABASE unitest;
GO

USE unitest;
GO

CREATE TABLE specialties (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
)

CREATE TABLE teachers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(255) NOT NULL
)

CREATE TABLE disciplines (
    id INT IDENTITY(1,1) PRIMARY KEY,
    teacher_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    semester TINYINT NOT NULL,
    CONSTRAINT fk_discipline_teacher FOREIGN KEY (teacher_id)
    REFERENCES teachers(id)
)

CREATE TABLE students (
    faculty_number VARCHAR(10) PRIMARY KEY NOT NULL,
    specialty_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    course TINYINT NOT NULL,
    email VARCHAR(255) NULL,
    CONSTRAINT fk_student_specialty FOREIGN KEY (specialty_id)
    REFERENCES specialties(id)
)

CREATE TABLE student_disciplines (
    student_fk VARCHAR(10) PRIMARY KEY NOT NULL,
    discipline_id INT NOT NULL,
    CONSTRAINT fk_student FOREIGN KEY (student_fk)
    REFERENCES students(faculty_number),
    CONSTRAINT fk_discipline FOREIGN KEY (discipline_id)
    REFERENCES disciplines(id)
)

CREATE TABLE tests (
    id INT IDENTITY(1,1) PRIMARY KEY,
    discipline_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    questions_count TINYINT NOT NULL DEFAULT 0,
    variants_count TINYINT NOT NULL DEFAULT 0,
    CONSTRAINT fk_test_discipline FOREIGN KEY (discipline_id)
    REFERENCES disciplines(id)
)

CREATE TABLE questions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    test_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    question_number TINYINT NOT NULL,
    variant_number TINYINT NOT NULL,
    CONSTRAINT fk_question_test FOREIGN KEY (test_id)
    REFERENCES tests(id),
    CONSTRAINT uniq_variant UNIQUE (test_id, question_number, variant_number)
)

CREATE TABLE answers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    question_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    correct BIT NOT NULL,
    CONSTRAINT fk_answer_question FOREIGN KEY (question_id)
    REFERENCES questions(id)
)

CREATE TABLE assessments (
    id INT IDENTITY(1,1) PRIMARY KEY,
    student_fn VARCHAR(10) NOT NULL,
    test_id INT NOT NULL,
    correct_answers INT NOT NULL DEFAULT 0,
    taken_at DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_assessment_student FOREIGN KEY (student_fn)
    REFERENCES students(faculty_number),
    CONSTRAINT fk_assessment_test FOREIGN KEY (test_id)
    REFERENCES tests(id)
)

CREATE TABLE assessment_answer (
    id INT IDENTITY(1,1) PRIMARY KEY,
    assessment_id INT NOT NULL,
    question_id INT NOT NULL,
    answer_id INT NOT NULL,
    CONSTRAINT fk_assessment FOREIGN KEY (assessment_id)
    REFERENCES assessments(id),
    CONSTRAINT fk_assessment_answer_question FOREIGN KEY (question_id)
    REFERENCES questions(id),
    CONSTRAINT fk_assessment_answer_answer FOREIGN KEY (answer_id)
    REFERENCES answers(id),
    CONSTRAINT uniq_answer UNIQUE (assessment_id, question_id, answer_id)
)

