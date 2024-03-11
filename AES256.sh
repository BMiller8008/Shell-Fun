#!/bin/bash

# Check for the correct number of command-line arguments
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <choice> <file_path> <key>"
  echo "choice: 1 for encryption, 2 for decryption"
  echo "file_path: Path to the input file"
  echo "key: Encryption/Decryption key"
  echo "Note: If you wish to provide inputs interactively, just run $0 without arguments."
  # Interactive mode banner and inputs if arguments are not provided
  if [ "$#" -eq 0 ]; then
    echo "======================================"
    echo "|    File Encryption & Decryption    |"
    echo "======================================"
    echo "| 1) Encrypt a file                  |"
    echo "| 2) Decrypt a file                  |"
    echo "======================================"
    read -p "| Enter your choice (1 or 2): " choice
    read -p "| Enter the path to the file: " filepath
    read -p "| Enter your key (will be adjusted to 256 bits): " userkey
  else
    exit 1
  fi
else
  # Assign command-line arguments to variables
  choice=$1
  filepath=$2
  userkey=$3
fi

echo "======================================"

# Validate choice
if [[ $choice -ne 1 && $choice -ne 2 ]]; then
  echo "| Invalid choice. Please run the script again and select either 1 or 2."
  echo "======================================"
  exit 1
fi

# Key adjustment
rawkey=$(printf '%-32s' "$userkey")
key=${rawkey:0:32}
hexkey=$(echo -n "$key" | xxd -p -c 32 | tr -d '\n')

# Encryption or decryption based on choice
if [ $choice -eq 1 ]; then
  # Encryption
  openssl enc -aes-256-cbc -salt -in "$filepath" -out "${filepath}.enc" -K "$hexkey" -iv "00000000000000000000000000000000"
  echo "| Encryption complete: ${filepath}.enc"
  echo "| Encrypted content:"
  cat "${filepath}.enc"
elif [ $choice -eq 2 ]; then
  # Decryption
  openssl enc -d -aes-256-cbc -in "$filepath" -out "${filepath%.enc}.dec" -K "$hexkey" -iv "00000000000000000000000000000000"
  echo "| Decryption complete: ${filepath%.enc}.dec"
  echo "| Decrypted content:"
  cat "${filepath%.enc}.dec"
fi

echo ""
echo "======================================"
