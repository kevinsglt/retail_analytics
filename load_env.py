from dotenv import load_dotenv
import os

load_dotenv()  # lit le .env

print("✅ Env chargé. DBT_HOST =", os.getenv("DBT_HOST"))