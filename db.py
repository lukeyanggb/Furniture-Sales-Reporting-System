from os import name
import psycopg2
from config import config

def execute(query):
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()
        # connect to the PostgreSQL server
        conn = psycopg2.connect(**params)
        # create a cursor
        cur = conn.cursor()    
	    # execute a statement
        cur.execute(query)
        # fetch the column names
        header = [desc[0] for desc in cur.description]
        # fetch all the records // rows
        table = cur.fetchall()
	    # close the communication with the PostgreSQL
        cur.close()
        return(header, table)
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def insert(query):
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()
        # connect to the PostgreSQL server
        conn = psycopg2.connect(**params)
        # create a cursor
        cur = conn.cursor()    
	    # execute a statement
        cur.execute(query)
        conn.commit()
        cur.close()
        return
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()

def update(query):
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()
        # connect to the PostgreSQL server
        conn = psycopg2.connect(**params)
        # create a cursor
        cur = conn.cursor()    
	    # execute a statement
        cur.execute(query)
        conn.commit()
        cur.close()
        return
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            conn.close()