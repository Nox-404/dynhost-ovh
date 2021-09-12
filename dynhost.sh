#!/usr/bin/env sh

# Account configuration
if [ -z $HOST ]
then
  echo "Missing HOST configuration environment." >&2
  exit 1
fi
if [ -z $LOGIN ]
then
  echo "Missing LOGIN configuration environment." >&2
  exit 1
fi
if [ -z $PASSWORD ]
then
  echo "Missing PASSWORD configuration environment." >&2
  exit 1
fi

# Get current IPv4 and corresponding configured
HOST_IP=$(dig +short $HOST A)
CURRENT_IP=$(curl -s -m 5 -4 ifconfig.co 2>/dev/null)
if [ -z $CURRENT_IP ]
then
  CURRENT_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)
fi

# Update dynamic IPv4, if needed
if [ -z $CURRENT_IP ] || [ -z $HOST_IP ]
then
  echo "No IP retrieved" >&2
  exit 2
else
  if [ "$HOST_IP" != "$CURRENT_IP" ]
  then
    RES=$(curl -m 5 -L --location-trusted --user "$LOGIN:$PASSWORD" "https://www.ovh.com/nic/update?system=dyndns&hostname=$HOST&myip=$CURRENT_IP")
    echo "IPv4 has changed - request to OVH DynHost: $RES"
  else
    echo "IPv4 has not changed - nothing to do"
  fi
fi
