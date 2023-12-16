import pyodbc
import sys

def connect_to_database(username, password):
    # Replace these values with your actual database connection details
    server = 'your_server_name'
    database = 'your_database_name'

    # Construct the connection string
    connection_string = f'DRIVER=SQL Server;SERVER={server};DATABASE={database};UID={username};PWD={password}'

    try:
        # Establish the database connection
        connection = pyodbc.connect(connection_string)
        print('Connected to the database successfully.')
        return connection
    except Exception as e:
        print(f'Error connecting to the database: {e}')
        sys.exit(1)

def execute_query(connection):
    cursor = connection.cursor()

    # Replace this query with your actual SQL query
    query = 'SELECT * FROM your_table_name'

    try:
        cursor.execute(query)
        print('Query executed successfully. Results:')
        
        # Fetch all the rows from the query result
        rows = cursor.fetchall()

        # Display the results
        for row in rows:
            print(row)
    except Exception as e:
        print(f'Error executing the query: {e}')
    finally:
        cursor.close()

if __name__ == "__main__":
    # Retrieve database credentials from command-line arguments
    db_username = sys.argv[1]
    db_password = sys.argv[2]

    print(f'Database Username: {db_username}')
    
    # Connect to the database
    db_connection = connect_to_database(db_username, db_password)

    try:
        # Execute a query
        execute_query(db_connection)
    finally:
        # Close the database connection
        db_connection.close()
        print('Database connection closed.')
