SLACK_WEBHOOK_URL=https://hooks.slack.com/services/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
SLACK_CHANNEL=ibs-skillset-happystays

app=service-registry
send_notification() {
  local color='good'
  local statusCheck = 'created'
  if [ "$status" == *"$statusCheck"*  ]; then
    color='good'
  else; then
    color = 'danger'
  fi
  local message="payload={\"channel\": \"#$SLACK_CHANNEL\",\"attachments\":[{\"pretext\":\"$1\",\"text\":\"$2\",\"color\":\"$color\"}]}"

  curl -X POST --data-urlencode "$message" ${SLACK_WEBHOOK_URL}
}

send_notification "*[AWS][DEPLOYMENT]*" "Deployed application *$app*"