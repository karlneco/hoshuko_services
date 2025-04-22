#!/bin/bash
# This script removes the specific port forwarding rules from iptables

set -e

echo "🧹 Removing iptables port forwarding rules..."

# Helper to remove rule only if it exists
remove_rule() {
    RULE=$1
    DESCRIPTION=$2

    if iptables -t nat -C PREROUTING $RULE 2>/dev/null; then
        iptables -t nat -D PREROUTING $RULE
        echo "❌ Removed rule for $DESCRIPTION"
    else
        echo "✔ No existing rule found for $DESCRIPTION"
    fi
}

remove_rule "-p tcp --dport 1473 -j REDIRECT --to-port 443" "absent app (port 1473 → 443)"
remove_rule "-p tcp --dport 9473 -j REDIRECT --to-port 443" "kanji app (port 9473 → 443)"

echo "✅ Port forwarding rules removed."