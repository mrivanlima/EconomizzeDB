# Set code page to UTF-8
chcp 65001

# Set the PGCLIENTENCODING environment variable
$env:PGCLIENTENCODING = "UTF8"



# Path to psql.exe
$psqlPath = "C:\Program Files\pgAdmin 4\runtime\psql.exe"

# Define connection parameters
$dbHost = "192.168.56.101"
$dbPort = "5432"
$dbName = "economizze"
$dbUser = "postgres"
$dbPassword = "postgres"  # Replace with your actual password
$sslMode = "prefer"
$connectTimeout = "10"

#Gitignore

# Path to the SQL script
$sqlScriptPath = "C:/Development/EconomizzeDB/master_script.sql"

# Construct the connection string
$connectionString = "host=$dbHost port=$dbPort dbname=$dbName user=$dbUser password=$dbPassword"

# Construct the SQL command to include the SQL script
$wrapperSql = @"
\i $sqlScriptPath
"@

# Write the wrapper SQL command to a temporary file
$tempSqlFile = [System.IO.Path]::GetTempFileName() + ".sql"
$wrapperSql | Out-File -FilePath $tempSqlFile -Encoding utf8

# Construct the command to execute the SQL script
$command = "& `"$psqlPath`" -d `"$dbName`" -h `"$dbHost`" -p $dbPort -U `"$dbUser`" -f `"$tempSqlFile`""

# Execute the command
Invoke-Expression $command

# Clean up the temporary file
Remove-Item -Path $tempSqlFile
