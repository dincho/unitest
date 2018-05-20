Online and up-to-date version can be found at: https://github.com/dincho/unitest

# Setup

## Run the docker image

```bash
docker run -d --name unitest unitest
```

## Run `sqlcmd`

```bash
docker exec -it unitest /opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P P@55w0rd
```

## Schema import

```sql
:r schema.sql
```

## Test Data

```sql
:r data.sql
```

## List all tables in the database

```sql
SELECT TABLE_NAME FROM unitest.INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
```


# Solutions

The solution has been implemented with total of 10 tables. For details see the EER Diagram below.

![EER Diagram](https://raw.githubusercontent.com/dincho/unitest/master/unitest_EER.png "EER Diagram").

## Triggers

### Assessment answers denormalization

For easy reporting and for the sake of the example a trigger with name `sync_assessment_answer`
is used to update assessment correct answers. The trigger itself calls SP `UpdateAssessmentCorrectAnswers`.


### Questions limits

To enforce test limits set by `max_questions` and `max_variants` a trigger named `limit_questions`
is setup for `questions` table inserts that checks and throw an error in case the limits are reached.

## Search for test assessment by student and discipline

### Examples

By student faculty number only:
```sql
EXEC FindAssessment @faculty_number = '111082';
```

By student faculty number only and discipline:
```sql
EXEC FindAssessment @faculty_number = '111082', @discipline = 'Computer networks and Internet';
```

Note that both parameters are wild-card, so the below example also works:
```sql
EXEC FindAssessment @faculty_number = '111', @discipline = 'Computer';
```

### Results
```
+-----------------+----------+--------------------------------+----------+-------------------------+
| Student name    | Fac. #   | Discipline                     | Test     | Date taken              |
|-----------------+----------+--------------------------------+----------+-------------------------|
| Ivan Petrov     | 111082   | Computer networks and Internet | SQL Quiz | 2018-04-21 08:12:00.000 |
| Ivan Petrov     | 111082   | Computer networks and Internet | SQL Quiz | 2018-04-20 08:44:00.000 |
| Gabriela Geneva | 111083   | Computer networks and Internet | SQL Quiz | 2018-04-20 08:20:00.000 |
+-----------------+----------+--------------------------------+----------+-------------------------+
```

## Average correct answers by test, question number and variant

Implemented with helper view `correct_answers_view` and wrapped in view `avg_correct_answers_view`.

### Examples

```sql
SELECT * FROM avg_correct_answers_view;
```

### Results

```
+----------+-----------+--------------------------------------------------------------------------------------+-----------------------+
| Test     | Variant   | Question                                                                             | avg_correct_answers   |
|----------+-----------+--------------------------------------------------------------------------------------+-----------------------|
| SQL Quiz | 1         | What does SQL stand for?                                                             | 0                     |
| SQL Quiz | 1         | Which SQL statement is used to extract data from a database?                         | 1                     |
| SQL Quiz | 1         | Which SQL statement is used to update data in a database?                            | 2                     |
| SQL Quiz | 2         | Which SQL statement is used to delete data from a database?                          | 0                     |
| SQL Quiz | 2         | Which SQL statement is used to insert new data in a database?                        | 1                     |
| SQL Quiz | 2         | With SQL, how do you select a column named "FirstName" from a table named "Persons"? | 1                     |
+----------+-----------+--------------------------------------------------------------------------------------+-----------------------+
```

## Average question and variants by disciplines

Implemented with helper view `tests_agg_view` and wrapped in view `disciplines_agg_view`.

### Examples

```sql
SELECT * FROM disciplines_agg_view;
```

### Results

```
+--------------------------------+-----------------+----------------+
| name                           | avg_questions   | avg_variants   |
|--------------------------------+-----------------+----------------|
| Computer networks and Internet | 6               | 2              |
| Internet servers and services  | 5               | 1              |
+--------------------------------+-----------------+----------------+
```

## Number of assessments with less than 50% success rate

Implemented with helper view `success_rate_view` and wrapped in SP `NumberOfFailedAssessments`.

### Examples

```sql
SELECT * FROM success_rate_view WHERE success_rate < 50;
```

```sql
EXEC NumberOfFailedAssessments;
```

### Results
```
+----------------------+
| failed_assessments   |
|----------------------|
| 5                    |
+----------------------+
```
