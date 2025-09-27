@echo off
echo Create and Load Bronze Layer into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\layers\bronze\create and load bronze.sql"
pause
