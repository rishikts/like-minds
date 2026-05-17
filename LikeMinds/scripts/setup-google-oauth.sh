#!/usr/bin/env bash
# One-time Google Sign-In setup for LikeMinds (iOS OAuth client).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
XCCONFIG="$ROOT/Config/GoogleOAuth.xcconfig"
GS_PLIST="$ROOT/Resources/GoogleService-Info.plist"

echo "=== Like Minds — Google Sign-In setup ==="
echo "Console: https://console.cloud.google.com/apis/credentials"
echo "Create OAuth client ID → iOS → Bundle ID: com.rishikts.likeminds"
echo ""

read -r -p "iOS CLIENT_ID (ends with .apps.googleusercontent.com): " CLIENT_ID
read -r -p "REVERSED_CLIENT_ID (com.googleusercontent.apps....): " REVERSED_ID

if [[ -z "$CLIENT_ID" || -z "$REVERSED_ID" ]]; then
  echo "Both values are required." >&2
  exit 1
fi

mkdir -p "$ROOT/Config"
cat > "$XCCONFIG" <<EOF
GOOGLE_CLIENT_ID = $CLIENT_ID
GOOGLE_REVERSED_CLIENT_ID = $REVERSED_ID
EOF

cat > "$GS_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CLIENT_ID</key>
	<string>$CLIENT_ID</string>
	<key>REVERSED_CLIENT_ID</key>
	<string>$REVERSED_ID</string>
	<key>BUNDLE_ID</key>
	<string>com.rishikts.likeminds</string>
</dict>
</plist>
EOF

chmod 600 "$XCCONFIG" "$GS_PLIST" 2>/dev/null || true
echo ""
echo "Wrote Config/GoogleOAuth.xcconfig and Resources/GoogleService-Info.plist"
echo "In Xcode: Product → Clean Build Folder, then Run."
