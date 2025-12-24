#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# Studio Deploy Script
# Deploys Next.js static export to studio.espadonne.com
# =============================================================================

SITE_NAME="studio.espadonne.com"
DEPLOY_ROOT="/var/www/${SITE_NAME}"
STAMP=$(date +%Y-%m-%d-%H%M%S)
OUTDIR=~/builds/$STAMP

# -----------------------------------------------------------------------------
# OS Detection & Service Commands
# -----------------------------------------------------------------------------
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/os-release ]]; then
        # Linux - check for specific distros
        source /etc/os-release
        case "$ID" in
            arch|cachyos|manjaro|endeavouros)
                echo "arch"
                ;;
            ubuntu|debian|pop|linuxmint)
                echo "debian"
                ;;
            fedora|rhel|centos|almalinux|rocky)
                echo "rhel"
                ;;
            *)
                echo "linux-generic"
                ;;
        esac
    else
        echo "unknown"
    fi
}

reload_nginx() {
    local os_type
    os_type=$(detect_os)

    echo "▶ reload nginx (detected: $os_type)"

    case "$os_type" in
        macos)
            if command -v brew &> /dev/null && brew services list | grep -q nginx; then
                sudo brew services reload nginx
            elif [[ -f /usr/local/etc/nginx/nginx.conf ]]; then
                sudo nginx -s reload
            else
                echo "⚠ nginx not found via Homebrew, attempting direct reload"
                sudo nginx -s reload
            fi
            ;;
        arch|debian|rhel|linux-generic)
            if command -v systemctl &> /dev/null; then
                sudo systemctl reload nginx
            elif command -v service &> /dev/null; then
                sudo service nginx reload
            else
                sudo nginx -s reload
            fi
            ;;
        *)
            echo "⚠ Unknown OS, attempting nginx -s reload"
            sudo nginx -s reload
            ;;
    esac
}

# -----------------------------------------------------------------------------
# Pre-flight checks
# -----------------------------------------------------------------------------
echo "▶ pre-flight checks"

if ! command -v npm &> /dev/null; then
    echo "✗ npm not found. Please install Node.js >= 20" >&2
    exit 1
fi

if ! command -v rsync &> /dev/null; then
    echo "✗ rsync not found. Please install rsync" >&2
    exit 1
fi

if ! command -v nginx &> /dev/null; then
    echo "✗ nginx not found. Please install nginx" >&2
    exit 1
fi

# Ensure deploy directories exist
sudo mkdir -p "${DEPLOY_ROOT}/releases"

# -----------------------------------------------------------------------------
# Build
# -----------------------------------------------------------------------------
echo "▶ git submodule update"
git submodule update --init --recursive

echo "▶ npm ci"
npm ci

echo "▶ npm run build (static export to ./out)"
npm run build

# Move build output to timestamped folder
mkdir -p ~/builds
mv out "$OUTDIR"

# -----------------------------------------------------------------------------
# Deploy
# -----------------------------------------------------------------------------
echo "▶ copy into releases"
sudo rsync -az --delete "$OUTDIR"/ "${DEPLOY_ROOT}/releases/${STAMP}/"

echo "▶ flip current symlink"
sudo ln -nfs "${DEPLOY_ROOT}/releases/${STAMP}" "${DEPLOY_ROOT}/current"

# -----------------------------------------------------------------------------
# Reload & Cleanup
# -----------------------------------------------------------------------------
reload_nginx

# Optional: clean up old releases (keep last 5)
echo "▶ cleanup old releases (keeping last 5)"
cd "${DEPLOY_ROOT}/releases" && ls -t | tail -n +6 | xargs -r sudo rm -rf

echo "✓ Deployed ${SITE_NAME} @ ${STAMP}"
