#!/usr/bin/env python3
import requests
import json
import sys
from datetime import datetime

BASE_URL = "http://localhost:3000"

def test_save_functionality():
    # Create a session
    session = requests.Session()
    
    # Navigate to get login page and cookies
    print("1. Getting login page...")
    response = session.get(f"{BASE_URL}/login")
    print(f"   Status: {response.status_code}")
    
    # Try to login (NextAuth credentials callback)
    print("2. Attempting login...")
    login_response = session.post(
        f"{BASE_URL}/api/auth/callback/credentials",
        json={
            "email": "admin@example.com",
            "password": "password123",
            "redirect": "false"
        }
    )
    print(f"   Status: {login_response.status_code}")
    print(f"   Response: {login_response.text[:200]}")
    
    # Get current event data
    print("3. Fetching event 2...")
    get_response = session.get(f"{BASE_URL}/api/records/2")
    if get_response.status_code != 200:
        print(f"   ERROR: Status {get_response.status_code}")
        print(f"   Response: {get_response.text}")
        return False
    
    event = get_response.json()
    current_year = event.get('year')
    print(f"   Current year: {current_year}")
    
    # Update with new year
    new_year = (current_year or 1500) + 5
    print(f"4. Updating event with new year {new_year}...")
    
    payload = {
        "event": {
            "type": "BAPTISM",
            "year": str(new_year),
            "month": "2",
            "day": "3",
            "sourceUrl": "",
            "notes": f"Test update at {datetime.now().isoformat()}",
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
    
    patch_response = session.patch(
        f"{BASE_URL}/api/records/2",
        json=payload
    )
    print(f"   Status: {patch_response.status_code}")
    print(f"   Response: {patch_response.text[:200]}")
    
    if patch_response.status_code != 200:
        print("   PATCH failed!")
        return False
    
    # Verify update
    print("5. Verifying update...")
    verify_response = session.get(f"{BASE_URL}/api/records/2")
    if verify_response.status_code != 200:
        print(f"   ERROR: Status {verify_response.status_code}")
        return False
    
    updated_event = verify_response.json()
    updated_year = updated_event.get('year')
    print(f"   Updated year: {updated_year}")
    
    if updated_year == new_year:
        print(f"✓ SUCCESS: Year was updated from {current_year} to {new_year}")
        return True
    else:
        print(f"✗ FAILED: Year is still {updated_year}, expected {new_year}")
        return False

if __name__ == "__main__":
    try:
        success = test_save_functionality()
        sys.exit(0 if success else 1)
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
