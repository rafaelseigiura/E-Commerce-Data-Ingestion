
import kagglehub
import os
from datetime import datetime
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
import pandas as pd
from pathlib import Path
load_dotenv()

# Download latest version
dataset_path = kagglehub.dataset_download("olistbr/brazilian-ecommerce")

print("Path to dataset files:", dataset_path)


connection_url = URL.create(
    "postgresql+psycopg2",
    username=os.getenv("POSTGRES_USER"),
    password=os.getenv("POSTGRES_PASSWORD"),
    host=os.getenv("POSTGRES_HOST"),
    port=int(os.getenv("POSTGRES_PORT")),
    database=os.getenv("POSTGRES_DB")
)

engine = create_engine(connection_url, connect_args={"client_encoding": "utf8"})



dataset_path = Path(dataset_path)

csv_files = list(dataset_path.glob("*.csv"))

ingestion_time = datetime.now()

for file in csv_files:
    table_name = (file.stem
                  .replace("olist_", "")
                  .replace("_dataset", "")
                  .lower())
    
    try:
        df = pd.read_csv(file)
    except UnicodeDecodeError:
        df = pd.read_csv(file, encoding="cp1252")
    
    df["source_file"] = file.name
    df["source_path"] = str(file)
    df["ingestion_timestamp"] = ingestion_time
    df["ingestion_date"] = ingestion_time.date()
    
    df.to_sql(
        name= f"olist_{table_name}",
        schema="bronze",
        con=engine,
        if_exists="replace",
        index=False
    )

    print(f"{file.name} -> bronze.{table_name}")
