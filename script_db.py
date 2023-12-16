import pyodbc
import sys

def connect_to_database(username, password):
    # Replace these values with your actual database connection details
    server = 'your_server_name'
    database = 'your_database_name'

    # Construct the connection string
    connection_string = f'DRIVER=SQL Server;SERVER={server};DATABASE={database};UID={username};PWD={password}'

    # Establish the database connection
    connection = pyodbc.connect(connection_string)

    return connection

def execute_query(connection):
    cursor = connection.cursor()

    # Replace this query with your actual SQL query
    query = 'SELECT * FROM your_table_name'

    cursor.execute(query)

    # Fetch all the rows from the query result
    rows = cursor.fetchall()

    # Display the results
    for row in rows:
        print(row)

if __name__ == "__main__":
    # Retrieve database credentials from command-line arguments
    db_username = sys.argv[1]
    db_password = sys.argv[2]

    # Connect to the database
    db_connection = connect_to_database(db_username, db_password)

    try:
        # Execute a query
        execute_query(db_connection)
    finally:
        # Close the database connection
        db_connection.close()
