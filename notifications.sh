SLACK_CHANNEL=skillset

app=service-registry
send_notification() {
  if [[ "$status" == *"checked"* || "$status" == *"unchanged"* ]]; then
    echo "It's there."
  else
    echo "It's not there."
  fi
  local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"pretext\":\"$1\",\"text\":\"$2\"}]}"

  curl -X POST --data-urlencode "$message" "$WEBHOOK_URL"
}

send_notification "*[AWS][DEPLOYMENT]*" "Deployed application *$app*"
