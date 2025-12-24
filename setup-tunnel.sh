#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Setup Cloudflared Tunnel for studio.espadonne.com
# Adds the studio subdomain to existing tunnel configuration
# =============================================================================

HOSTNAME="studio.espadonne.com"
SERVICE="http://localhost:80"
CONFIG_FILE="/etc/cloudflared/config.yml"
BACKUP_FILE="/etc/cloudflared/config.yml.backup.$(date +%Y%m%d%H%M%S)"

echo "▶ Setting up cloudflared tunnel for ${HOSTNAME}"

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo"
    echo "Usage: sudo ./setup-tunnel.sh"
    exit 1
fi

# Check if config file exists
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "✗ Cloudflared config not found at ${CONFIG_FILE}"
    exit 1
fi

# Check if hostname already exists in config
if grep -q "hostname: ${HOSTNAME}" "$CONFIG_FILE"; then
    echo "✓ ${HOSTNAME} already configured in ${CONFIG_FILE}"
    echo "  No changes needed."
    exit 0
fi

# Backup existing config
echo "▶ Backing up existing config to ${BACKUP_FILE}"
cp "$CONFIG_FILE" "$BACKUP_FILE"

# Add the new ingress rule
# Strategy: Find the catch-all rule (line with just "- service:") and insert before it
echo "▶ Adding ${HOSTNAME} to ingress rules"

# Create the new rule text (2-space YAML indent)
NEW_RULE="  - hostname: ${HOSTNAME}
    service: ${SERVICE}"

# Use awk to insert the new rule before the catch-all (a line starting with "  - service:" without hostname)
awk -v new_rule="$NEW_RULE" '
    /^[[:space:]]*- service:/ && !found_catchall {
        # This is the catch-all rule (no hostname before it)
        print new_rule
        found_catchall = 1
    }
    { print }
' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"

# Check if we actually added the rule
if grep -q "hostname: ${HOSTNAME}" "${CONFIG_FILE}.tmp"; then
    mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "✓ Added ${HOSTNAME} to ingress rules"
else
    # Fallback: append before last line if no catch-all pattern matched
    rm -f "${CONFIG_FILE}.tmp"

    # Check if ingress section exists
    if grep -q "^ingress:" "$CONFIG_FILE"; then
        # Use sed to insert after "ingress:" line
        sed -i "/^ingress:/a\\
  - hostname: ${HOSTNAME}\\
    service: ${SERVICE}" "$CONFIG_FILE"
        echo "✓ Added ${HOSTNAME} to ingress rules (appended to ingress)"
    else
        echo "✗ Could not find ingress section in config"
        echo "  Please add manually:"
        echo ""
        echo "ingress:"
        echo "  - hostname: ${HOSTNAME}"
        echo "    service: ${SERVICE}"
        echo "  - service: http_status:404"
        exit 1
    fi
fi

# Verify the config is valid
echo "▶ Validating cloudflared config"
if cloudflared tunnel ingress validate 2>/dev/null; then
    echo "✓ Config validation passed"
else
    echo "⚠ Config validation returned warnings (this may be OK)"
fi

# Restart cloudflared
echo "▶ Restarting cloudflared service"
systemctl restart cloudflared

# Wait a moment and check status
sleep 2
if systemctl is-active --quiet cloudflared; then
    echo "✓ cloudflared is running"
else
    echo "✗ cloudflared failed to start. Restoring backup..."
    cp "$BACKUP_FILE" "$CONFIG_FILE"
    systemctl restart cloudflared
    echo "  Backup restored. Check logs: journalctl -u cloudflared -n 50"
    exit 1
fi

echo ""
echo "✓ Tunnel configured for ${HOSTNAME}"
echo ""
echo "Next steps:"
echo "  1. Add DNS record in Cloudflare Dashboard:"
echo "     - Type: CNAME"
echo "     - Name: studio"
echo "     - Target: (your tunnel ID).cfargotunnel.com"
echo "     - Proxy: ON (orange cloud)"
echo ""
echo "  2. Set up nginx and deploy:"
echo "     sudo cp studio.espadonne.com.nginx.conf /etc/nginx/sites-available/"
echo "     sudo ln -s /etc/nginx/sites-available/studio.espadonne.com.nginx.conf /etc/nginx/sites-enabled/"
echo "     sudo nginx -t && sudo systemctl reload nginx"
echo "     ./deploy.sh"
