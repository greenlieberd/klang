#!/bin/bash
# Runs on session end (Stop hook).
# Updates last_session timestamp in state/active.json.

python3 - << 'EOF'
import json, datetime
try:
    with open('state/active.json', 'r') as f:
        d = json.load(f)
    d['last_session'] = datetime.datetime.now().isoformat()
    with open('state/active.json', 'w') as f:
        json.dump(d, f, indent=2)
except Exception as e:
    pass  # Non-fatal
EOF
