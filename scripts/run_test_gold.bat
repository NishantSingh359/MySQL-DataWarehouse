@echo off
echo Gold Layer Data Quality Check into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --local-infile=1 -u root -p1234 bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\test\test_gold.sql"
pause