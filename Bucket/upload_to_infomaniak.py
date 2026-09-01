#!/usr/bin/env python3
"""
Upload example.txt to an Infomaniak S3-compatible bucket.

Requires: pip3 install boto3 --break-system-packages

Set these environment variables before running (or edit the CONFIG
section below directly if you prefer):

    export INFOMANIAK_ACCESS_KEY="your_access_key"
    export INFOMANIAK_SECRET_KEY="your_secret_key"
    export INFOMANIAK_BUCKET="your_bucket_name"
    export INFOMANIAK_ENDPOINT="https://s3.pub1.infomaniak.cloud"
    export INFOMANIAK_REGION="pub1"

Then run:
    python3 upload_to_infomaniak.py
"""

import os
import sys
import boto3
from botocore.config import Config
from botocore.exceptions import ClientError, NoCredentialsError

# ---------------------------------------------------------------------------
# CONFIG - edit these if you don't want to use environment variables
# ---------------------------------------------------------------------------
ACCESS_KEY = os.environ.get("INFOMANIAK_ACCESS_KEY", "0074cb619b794c06ad12c9e4a41771ce")
SECRET_KEY = os.environ.get("INFOMANIAK_SECRET_KEY", "9f97917d5a9a4d9bab73061f795d0c66")
BUCKET_NAME = os.environ.get("INFOMANIAK_BUCKET", "my-first-container")
ENDPOINT_URL = os.environ.get("INFOMANIAK_ENDPOINT", "https://s3.pub1.infomaniak.cloud")
#ENDPOINT_URL = os.environ.get("INFOMANIAK_ENDPOINT", "https://s3.pub1.infomaniak.cloud/object/v1/AUTH_cd914a6bdafc40d7a843726f90774aab")
REGION_NAME = os.environ.get("INFOMANIAK_REGION", "us-east-1")
forcePathStyle=True
 
LOCAL_FILE = "example.txt"       # file to upload (must exist in the current folder)
REMOTE_KEY = "example.txt"       # name/path it will have inside the bucket
# ---------------------------------------------------------------------------


def main():
    missing = [
        name for name, val in [
            ("INFOMANIAK_ACCESS_KEY", ACCESS_KEY),
            ("INFOMANIAK_SECRET_KEY", SECRET_KEY),
            ("INFOMANIAK_BUCKET", BUCKET_NAME),
        ] if not val
    ]
    if missing:
        print(f"Missing required config: {', '.join(missing)}")
        print("Set them as environment variables, or edit the CONFIG section in this script.")
        sys.exit(1)
 
    if not os.path.isfile(LOCAL_FILE):
        print(f"Local file not found: {os.path.abspath(LOCAL_FILE)}")
        sys.exit(1)
 
    s3 = boto3.client(
        "s3",
        endpoint_url=ENDPOINT_URL,
        region_name=REGION_NAME,
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY,
        config=Config(
            s3={"addressing_style": "path"},  # avoids region auto-detection issues
            signature_version="s3v4",
            request_checksum_calculation="when_required",  # avoids aws-chunked, unsupported by Infomaniak
            response_checksum_validation="when_required",
        ),
    )
 
    print(f"Uploading '{LOCAL_FILE}' to bucket '{BUCKET_NAME}' as '{REMOTE_KEY}'...")
    try:
        s3.upload_file(LOCAL_FILE, BUCKET_NAME, REMOTE_KEY)
        print("Upload successful.")
    except NoCredentialsError:
        print("Error: invalid or missing credentials.")
        sys.exit(1)
    except ClientError as e:
        print(f"Error from Infomaniak S3: {e}")
        sys.exit(1)
    except RecursionError:
        print("Recursion error: check that ENDPOINT_URL and REGION_NAME are set correctly.")
        sys.exit(1)
    except Exception as e:
        print("Error:")
        print(e)
 
 
if __name__ == "__main__":
    main()
 

