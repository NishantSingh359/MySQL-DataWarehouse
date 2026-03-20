@echo off
echo Create and Load Bronze Layer into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --local-infile=1 -u root -p1234 bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\sql\bronze.sql
pause

@echo off
echo Create and Load Silver Layer into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --local-infile=1 -u root -p1234 bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\sql\silver.sql
pause

@echo off
echo Create and Load Gold Layer into MySQL...
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" --local-infile=1 -u root -p1234 bronze < "C:\Users\TUF\OneDrive\Documents\Code\MY SQL\MySQL-DataWarehouse\sql\gold.sql
pause