#!/bin/sh
set -e
cd $HOME
if [ ! -n "$WERCKER_CF_INVALIDATE_KEY_ID" ]
then
    fail 'missing or empty option key_id, please check wercker.yml'
fi

if [ ! -n "$WERCKER_CF_INVALIDATE_KEY_SECRET" ]
then
    fail 'missing or empty option key_secret, please check wercker.yml'
fi

if [ ! -n "$WERCKER_CF_INVALIDATE_DISTRIBUTION_ID" ]
then
    fail 'missing or empty option distribution_id, please check wercker.yml'
fi

if [ ! -n "$WERCKER_CF_INVALIDATE_PATH" ]
then
    fail 'missing or empty option path, please check wercker.yml'
fi

content_type="text/xml"
date="$(LC_ALL=C date -u +"%a, %d %b %Y %X %z")"

body="<InvalidationBatch><Path>$WERCKER_CF_INVALIDATE_PATH</Path><CallerReference>ref_$(( ( RANDOM % 100000 )  + 1 ))</CallerReference></InvalidationBatch>"

sig="$(printf "$date" | openssl sha1 -binary -hmac "$WERCKER_CF_INVALIDATE_KEY_SECRET" | base64)"

curl https://cloudfront.amazonaws.com/2010-08-01/distribution/$WERCKER_CF_INVALIDATE_DISTRIBUTION_ID/invalidation \
-H "Date: $date" \
-H "Authorization: AWS $WERCKER_CF_INVALIDATE_KEY_ID:$sig" \
-H "Content-Type: $content_type"

if [[ $? -ne 0 ]];then
  fail 'invalidation failed';
else
  success 'finished invalidation';
fi

set -e
