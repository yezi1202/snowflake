echo Creating project: %cd%

:: Create folders
mkdir .\sql\tables
mkdir .\sql\views
mkdir .\sql\procedures
mkdir .\.github\workflows

:: Create files
type nul > .\deploy.sql
type nul > .\snowflake.yml
type nul > .\requirements.txt
type nul > .\.github\workflows\deploy.yml

:: Write deploy.sql
(
echo -- tables
echo -- !source sql/tables/001_create_table.sql
echo.
echo -- views
echo -- !source sql/views/001_create_view.sql
echo.
echo -- procedures
echo -- !source sql/procedures/001_create_procedure.sql
) > .\deploy.sql

:: Write snowflake.yml
(
echo definition_version: 1
echo.
echo scripts:
echo   - name: deploy_all
echo     script: deploy.sql
) > .\snowflake.yml

:: Write deploy.yml
(
echo name: Snowflake CI/CD
echo.
echo on:
echo   push:
echo     branches:
echo       - main
echo.
echo jobs:
echo   deploy:
echo     runs-on: ubuntu-latest
echo.
echo     steps:
echo       - uses: actions/checkout@v3
echo.
echo       - name: Install Snowflake CLI
echo         run: pip install snowflake-cli-labs
echo.
echo       - name: Deploy SQL
echo         env:
echo           SNOWFLAKE_CONNECTIONS_MYCONN_ACCOUNT: ${{ secrets.ACCOUNT }}
echo           SNOWFLAKE_CONNECTIONS_MYCONN_USER: ${{ secrets.USER }}
echo           SNOWFLAKE_CONNECTIONS_MYCONN_PASSWORD: ${{ secrets.PASSWORD }}
echo         run: ^
echo           snow connection test --connection myconn ^&^& ^
echo           snow run deploy_all --connection myconn
) > .\.github\workflows\deploy.yml

echo Project created successfully!