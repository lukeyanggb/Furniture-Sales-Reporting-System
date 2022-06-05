## Furniture Sales Reporting System
Furniture Sales Reporting System is a sales reporting system with a dashboard UI to support enterprise decision making. It is designed and optimized for reporting and analysis over millions of records.

## Postgresql configuration file
You need a configuration file named `database.ini` to store all connection parameters.
The following shows the contents of the `database.ini` file:
```
[postgresql]
host=localhost
database=databasename
user=username
password=userpassword
```

Change `database`, `user`, `password` values to your local postgresql configurations. Notice that you need to add the `database.ini` to the `.gitignore` file to not committing the sensitive information to the public.

## Setup
`PostgreSQL` needs to be installed and running, `database.ini` with correct credentials created in the root directory.
Run the following commands on terminal:

If `pip install -r requirements.txt` doesn't work, try `pip3 install -r requirements.txt`
```
git clone https://github.com/lukeyanggb/Furniture-Sales-Reporting-System.git
cd Furniture-Sales-Reporting-System
pip install -r requirements.txt
psql -f SchemaAndDemoData.sql
python3 app.py
```

## Dependencies
* Python>=3.7.9
* Flask==1.1.2
* psycopg2==2.7.7
* Flask-WTF==0.14.3
* Flask-Bootstrap4==4.0.2
* WTForms==2.3.3
* PostgreSQL>=12.1
* tablefunc module installed for PostgreSQL to make pivot table:
```sql
CREATE EXTENSION IF NOT EXISTS tablefunc;
```