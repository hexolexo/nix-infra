#!/usr/bin/env bash
# add-peer.sh

NAME=$1

if [ -z "$NAME" ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

# Get next IP
NEXT_IP=$(awk '{print $2}' peers.txt | sort -n | tail -1)
NEXT_IP=$((NEXT_IP + 1))

# Generate keypair
PRIVATE=$(wg genkey)
PUBLIC=$(echo "$PRIVATE" | wg pubkey)

# Add to peers.txt
echo "$NAME $NEXT_IP $PUBLIC keepalive" >> peers.txt

# Generate client config
cat > "${NAME}-wg.conf" <<EOF
[Interface]
PrivateKey = ${PRIVATE}
Address = 10.0.0.${NEXT_IP}/24

[Peer]
PublicKey = $(cat /etc/wireguard/public)
Endpoint = $(ssh server "curl -s ifconfig.me"):51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

# QR code for mobile
qrencode -t ansiutf8 < "${NAME}-wg.conf"

echo "Added ${NAME} at 10.0.0.${NEXT_IP}"
echo "Config saved to ${NAME}-wg.conf"
