#!/bin/bash
# mandatory settings
export WEBHOOK_RECEIVER_PORT=8089
export WEBHOOK_RECEIVER_MOUNT_POINT=webhooks
export WEBHOOK_RECEIVER_LOG_FILE=/tmp/webhook_receiver.log
export WEBHOOK_RECEIVER_PROCESS_EVENT_SCRIPT=integrations/servicenow/process_webhook_event.rb

# custom settings
export WEBHOOK_RECEIVER_BRPM_HOST=localhost
export WEBHOOK_RECEIVER_BRPM_PORT=8088
export WEBHOOK_RECEIVER_BRPM_TOKEN=???
export WEBHOOK_RECEIVER_INTEGRATION_ID=<the id of the ServiceNow integration in BRPM>

webhook_receiver
