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

If failed to load all data by `psql -f SchemaAndDemoData.sql`, go to the directory of data folder and manually load all data in `psql` command line:
```sql
\COPY City FROM 'City.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Store FROM 'Store.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Campaign FROM 'Campaign.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Product FROM 'Product.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Category FROM 'Category.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY InCategory FROM 'InCategory.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Holiday FROM 'Holiday.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Discount FROM 'Discount.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
\COPY Transaction FROM 'Transaction.csv' WITH DELIMITER AS ',' CSV ESCAPE '"';
```
## Dependencies
* Python>=3.7.9
* Flask==1.1.2
* psycopg2==2.7.7
* Flask-WTF==0.14.3
* Flask-Bootstrap4==4.0.2
* WTForms==2.3.3
* PostgreSQL>=12.1