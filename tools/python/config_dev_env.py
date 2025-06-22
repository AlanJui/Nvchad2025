import os

from dotenv import load_dotenv

# Get the path to he directory this file is in
BASEDIR = os.path.abspath(os.path.dirname(__file__))
# Load environment variables
load_dotenv(os.path.join(BASEDIR, 'config.env'))
CHROMEDRIVER_PATH = os.getenv('CHROMEDRIVER_PATH')

# URLs
KONG_UN_DICT_URL='https://ctext.org/dictionary.pl?if=gb'
JQUERYUI_URL='https://jqueryui.com'
PYTHON_URL='https://python.org'
PYTHON_DOWNLOADS_URL='https://python.org/downloads'
QUOTESTOSCRAPE_URL='https://quotes.toscrape.com'
SELENIUM_DOCS_SEARCH_URL='https://selenium-python.readthedocs.io/search.html'
SELENIUM_URL = 'https://selenium.dev'
WIKIPEDIA_URL='https://wikipedia.org'

# Constants
WAIT_TIME = 5  # seconds

# Database
# DATABASE = '.\\Kong_Un.db'
DATABASE = '.\\Nga_Siok_Thong_Ji_Tian.db'