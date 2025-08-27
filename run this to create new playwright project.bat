@echo off
setlocal enabledelayedexpansion

REM Ask for project folder name
set /p foldername="Enter the name of your Playwright project folder: "

REM Create the folder
mkdir %foldername%
cd %foldername%

REM Create virtual environment
echo Creating virtual environment...
python -m venv venv

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate

REM Create folders for Playwright + Pytest framework
mkdir tests
mkdir pages
mkdir utils
mkdir Reports
mkdir Reports\screenshots
mkdir Reports\logs

REM Create pytest.ini with content
(
echo [pytest]
echo.
echo addopts = --headed --browser firefox --html=reports/report.html --self-contained-html
echo testpaths = tests --slowmo=200
) > pytest.ini

REM Create conftest.py with Playwright fixtures
(
echo import pytest
echo from playwright.sync_api import sync_playwright
echo.
echo.
echo @pytest.fixture^(scope="session"^)
echo def browser^(^):
echo     with sync_playwright^(^) as p:
echo         browser = p.chromium.launch^(headless=False^)
echo         yield browser
echo         browser.close^(^)
echo.
echo.
echo @pytest.fixture
echo def page^(browser^):
echo     page = browser.new_page^(^)
echo     yield page
echo     page.close^(^)
) > conftest.py

REM Install required packages inside venv
echo Installing dependencies...
pip install pytest pytest-playwright pytest-html playwright pytest-xdist

REM Install Playwright browsers
playwright install

echo Project setup for '%foldername%' completed successfully!

code .

exit