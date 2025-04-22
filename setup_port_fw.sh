#!/bin/bash
# This script sets up port forwarding so that external ports 1473 and 9473 redirect to Traefik's 443

set -e

echo "🔧 Enabling IP forwarding..."
sysctl -w net.ipv4.ip_forward=1

echo "🛡 Ensuring iptables rules are in place..."

# Helper to add rule only if it's not already added
ensure_rule() {
    RULE=$1
    DESCRIPTION=$2

    if iptables -t nat -C PREROUTING $RULE 2>/dev/null; then
        echo "✔ Rule already exists for $DESCRIPTION"
    else
        iptables -t nat -A PREROUTING $RULE
        echo "➕ Added rule for $DESCRIPTION"
    fi
}

ensure_rule "-p tcp --dport 1473 -j REDIRECT --to-port 443" "absent app (port 1473 → 443)"
ensure_rule "-p tcp --dport 9473 -j REDIRECT --to-port 443" "kanji app (port 9473 → 443)"

echo "✅ Port forwarding set up:"
echo "  - Port 1473 → absent.calgaryhoshuko.org"
echo "  - Port 9473 → kanjisoft.calgaryhoshuko.org"