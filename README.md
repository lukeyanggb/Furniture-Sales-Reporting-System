# cs6400-2021-01-Team054
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

## Dependencies
* Python>=3.7.9
* Flask==1.1.2
* psycopg2==2.7.7
* Flask-WTF==0.14.3
* WTForms==2.3.3
* PostgreSQL>=12.1
* tablefunc module installed for PostgreSQL to make pivot table.
