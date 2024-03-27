import pandas as pd
import sys


def convert_csv_to_parquet(csv_file_path):
    # Assuming the CSV does not contain an index column at the first position
    df = pd.read_csv(csv_file_path)

    # Construct the Parquet file path
    parquet_file_path = csv_file_path.rsplit(".", 1)[0] + ".parquet"

    # Convert and save as Parquet
    df.to_parquet(parquet_file_path, engine="fastparquet", index=False)

    print(f"Converted {csv_file_path} to {parquet_file_path}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python convert_csv_to_parquet.py <path_to_csv_file>")
        sys.exit(1)

    csv_file_path = sys.argv[1]
    convert_csv_to_parquet(csv_file_path)
