#!/bin/sh

echo "Initialize cozy-core"

# Initialize Database
until curl --fail --silent --show-error ${COZY_COUCHDB_URL}; do
	echo "Database is unreachable !"
	echo "Will try in 10 seconds ..."
	sleep 10
done
curl --fail --silent --show-error -X PUT ${COZY_COUCHDB_URL}/_users
curl --fail --silent --show-error -X PUT ${COZY_COUCHDB_URL}/_replicator
curl --fail --silent --show-error -X PUT ${COZY_COUCHDB_URL}/_global_changes

# Run server
su cozy -c "cozy-stack serve  --config /etc/cozy/cozy.yml" &

sleep 10

# Create instance and install applications
su cozy -c "cozy-stack instances add --host 0.0.0.0 --apps ${COZY_APPS} --passphrase ${COZY_ADMIN_PASSPHRASE} ${COZY_DOMAIN}" &

# Monitor logs
rsyslogd -n