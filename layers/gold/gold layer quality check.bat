@echo off
echo Gold Layer Data Quality Check into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\layers\gold\gold layer quality check.sql"
pause