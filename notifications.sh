SLACK_WEBHOOK_URL=https://hooks.slack.com/services/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
SLACK_CHANNEL=skillset

app=service-registry
send_notification() {
  if [[ "$status" == *"checked"* || "$status" == *"unchanged"* ]]; then
    echo "It's there."
  else
    echo "It's not there."
  fi
  local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"pretext\":\"$1\",\"text\":\"$2\"}]}"

  curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}

send_notification "*[AWS][DEPLOYMENT]*" "Deployed application *$app*"
