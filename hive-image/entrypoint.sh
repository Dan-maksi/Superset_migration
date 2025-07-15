#!/bin/bash
set -e

echo "Initializing Hive Metastore schema..."
schematool -dbType postgres -initSchema || echo "Schema likely already exists. Continuing..."

echo "Starting Hive Metastore..."
/opt/hive/bin/hive --service metastore