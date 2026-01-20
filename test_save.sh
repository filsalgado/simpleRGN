#!/bin/bash

# Test script to verify PATCH save functionality

BASE_URL="http://localhost:3000"
TEST_EMAIL="admin@example.com"
TEST_PASSWORD="password123"

echo "=== Testing Save Functionality ==="
echo "1. Logging in..."

# Login to get session
LOGIN_RESPONSE=$(curl -s -c /tmp/cookies.txt -X POST "$BASE_URL/api/auth/callback/credentials" \
  -H "Content-Type: application/json" \
  -d "{\"email\": \"$TEST_EMAIL\", \"password\": \"$TEST_PASSWORD\", \"redirect\": false}")

echo "Login response: $LOGIN_RESPONSE"

# Check if we have cookies
if [ ! -f /tmp/cookies.txt ]; then
    echo "ERROR: No cookies file created"
    exit 1
fi

echo "2. Fetching current event data..."
GET_RESPONSE=$(curl -s -b /tmp/cookies.txt "$BASE_URL/api/records/2")
echo "GET response: $GET_RESPONSE"

# Extract current year
CURRENT_YEAR=$(echo "$GET_RESPONSE" | grep -o '"year":[0-9]*' | head -1 | cut -d':' -f2)
echo "Current year: $CURRENT_YEAR"

NEW_YEAR=$((CURRENT_YEAR + 10))
echo "3. Updating year to $NEW_YEAR via PATCH..."

# Create payload
PAYLOAD=$(cat <<EOF
{
  "event": {
    "type": "BAPTISM",
    "year": "$NEW_YEAR",
    "month": "2",
    "day": "3",
    "sourceUrl": "",
    "notes": "Test update",
    "parishId": "1"
  },
  "subjects": {
    "primary": {
      "id": "1",
      "role": "SUBJECT",
      "name": "João Batista",
      "nickname": "",
      "professionId": "",
      "professionOriginal": "",
      "origin": "",
      "residence": "",
      "deathPlace": "",
      "titleId": "",
      "sex": "M",
      "legitimacyStatusId": ""
    }
  },
  "participants": []
}
EOF
)

PATCH_RESPONSE=$(curl -s -b /tmp/cookies.txt -X PATCH "$BASE_URL/api/records/2" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

echo "PATCH response: $PATCH_RESPONSE"

# Verify update
echo "4. Verifying update by fetching event again..."
VERIFY_RESPONSE=$(curl -s -b /tmp/cookies.txt "$BASE_URL/api/records/2")
VERIFY_YEAR=$(echo "$VERIFY_RESPONSE" | grep -o '"year":[0-9]*' | head -1 | cut -d':' -f2)

if [ "$VERIFY_YEAR" = "$NEW_YEAR" ]; then
    echo "✓ SUCCESS: Year was updated from $CURRENT_YEAR to $NEW_YEAR"
else
    echo "✗ FAILED: Year is still $VERIFY_YEAR, expected $NEW_YEAR"
    exit 1
fi

# Clean up
rm -f /tmp/cookies.txt
