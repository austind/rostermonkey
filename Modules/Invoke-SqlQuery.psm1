# Execute SQL query
Function Invoke-SqlQuery {
    Param (
        [string]$SqlServer,
        [string]$SqlUser,
        [string]$SqlPassword,
        [string]$SqlDb,
        [string]$SqlQuery
    )
    # Connect to SQL Server and execute $SqlQuery.
    $SQLConnection = New-Object System.Data.SqlClient.SqlConnection
    $SQLConnection.ConnectionString = "Server = ${SQLServer}; Database = ${SQLDB}; uid = ${SQLUser}; pwd = ${SQLPassword};"
    $SQLCmd = New-Object System.Data.SqlClient.SqlCommand
    $SQLCmd.CommandText = $SQLQuery
    $SQLCmd.Connection = $SQLConnection
    $SQLAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SQLAdapter.SelectCommand = $SQLCmd

    # Creates a new dataset with the results of query and fills it
    $SQLDataSet = New-Object System.Data.DataSet
    $SQLAdapter.Fill($SQLDataSet) | Out-Null

    # Close connection
    $SQLConnection.Close()

    # Return dataset
    Return [PsObject]$SQLDataSet.Tables[0]
}