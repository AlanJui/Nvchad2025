import os

# py -m pip install python-dotenv
from dotenv import dotenv_values

# Get the path to he directory this file is in
# BASEDIR = os.path.abspath(os.path.dirname(__file__))
# CONFIG_FILE = ".env"
# Load environment variables
# load_dotenv(os.path.join(BASEDIR, CONFIG_FILE))
config = dotenv_values(".env")


def get_input_file_path():
    dir_path = config["INPUT_FILE_PATH"]
    file_name = config["FILE_NAME"]
    return os.path.join(dir_path, file_name)


def get_tai_gi_zu_im_bun_path():
    dir_path = config["TAI_GI_ZU_IM_BUN_PATH"]
    file_name = config["TAI_GI_ZU_IM_BUN_FILE_NAME"]
    return os.path.join(dir_path, file_name)


def get_database_path():
    return config["DATABASE_PATH"]