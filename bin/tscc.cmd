@echo off
rem Stands in for gcc for the tree-sitter CLI; see tscc.py.
python "%~dp0tscc.py" %*
exit /b %errorlevel%
