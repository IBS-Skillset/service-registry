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

  curl -X POST -H 'Content-type: application/json' --data '{"text":"Hello, World!"}' ${SLACK_WEBHOOK_URL}
}

send_notification "*[AWS][DEPLOYMENT]*" "Deployed application *$app*"
