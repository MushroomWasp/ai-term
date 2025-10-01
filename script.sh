#!/bin/bash

# Usage:
#   ./script.sh "Your prompt here"
#   ./script.sh -c "Your prompt here"   # code-only mode

API_KEY="XXXX"
MODEL="gemini-2.0-flash"

if [ $# -eq 0 ] || [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage:"
  echo "  $(basename "$0") \"your prompt here\""
  echo "  $(basename "$0") -c \"your prompt here\"   # code-only mode"
  exit 0
fi

# Check for -c / --code flag
CODE_ONLY=false
if [[ "$1" == "-c" || "$1" == "--code" ]]; then
  CODE_ONLY=true
  shift
fi

PROMPT="$*"

# Modify prompt if code-only mode
if [ "$CODE_ONLY" = true ]; then
  PROMPT="$PROMPT. Respond ONLY with the code, no explanations or extra text."
fi

RESPONSE=$(curl -s "https://generativelanguage.googleapis.com/v1beta/models/$MODEL:generateContent" \
  -H 'Content-Type: application/json' \
  -H "X-goog-api-key: $API_KEY" \
  -X POST \
  -d "{
    \"contents\": [
      {
        \"parts\": [
          {
            \"text\": \"$PROMPT\"
          }
        ]
      }
    ]
  }" | jq -r '.candidates[0].content.parts[0].text')

# Show nicely with glow if available
if command -v glow &> /dev/null; then
  echo "$RESPONSE" | glow -
else
  echo "$RESPONSE"
fi
