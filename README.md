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


## Search for test assessment by student and discipline

### Examples

By student faculty number only:
```sql
EXEC FindAssessment '111082';
```

By student faculty number only and discipline:
```sql
EXEC FindAssessment '111082', 'Computer networks and Internet';
```

Note that both parameters are wild-card, so the below example also works:
```sql
EXEC FindAssessment '111', 'Computer';
```

### Results


## Average correct answers by test, question number and variant
?????

### Examples

### Results



## Number of assessments with less than 50% success rate

### Examples
```sql
SELECT * FROM success_rate_view WHERE success_rate < 50;
```

```sql
EXEC NumberOfFailedAssessments;
```

### Results
