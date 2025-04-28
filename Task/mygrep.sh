#!/bin/bash

if [ "$1" == "--help" ]; then
  echo "How to use:"
  echo "  $0 [options] word_to_find file_name"
  echo "Options:"
  echo "  -n  Show line numbers"
  echo "  -v  Show lines that do NOT match"
  exit 0
fi

if [ "$#" -lt 2 ]; then
  echo "Not enough arguments!"
  echo "Usage: $0 [options] word_to_find file_name"
  exit 1
fi

option=""
word_to_find=""
file_name=""

if [[ "$1" == -* ]]; then
  option="$1"
  word_to_find="$2"
  file_name="$3"
else
  word_to_find="$1"
  file_name="$2"
fi

if [ -z "$word_to_find" ] || [ -z "$file_name" ]; then
  echo "You forgot to give the word or the file!"
  exit 1
fi

if [ ! -f "$file_name" ]; then
  echo "Oops! File '$file_name' does not exist."
  exit 1
fi

line_number=0  

while IFS= read -r current_line; do
  line_number=$((line_number + 1))  

  line_in_small=$(echo "$current_line" | tr '[:upper:]' '[:lower:]')
  word_in_small=$(echo "$word_to_find" | tr '[:upper:]' '[:lower:]')

  if [[ "$line_in_small" == *"$word_in_small"* ]]; then
    is_match=true
  else
    is_match=false
  fi

  if [[ "$option" == *v* ]]; then
    if [ "$is_match" == true ]; then
      is_match=false
    else
      is_match=true
    fi
  fi

  if [ "$is_match" == true ]; then
    if [[ "$option" == *n* ]]; then
      echo "${line_number}:$current_line"
    else
      echo "$current_line"
    fi
  fi

done < "$file_name"
