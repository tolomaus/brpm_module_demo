# JIRA to BRPM integration
## Intro
This integration will automatically synchronize JIRA issues with BRPM tickets when an issue is created, updated or deleted in JIRA. This is just a first step in integrating JIRA with BRPM. It can easily be extended to cover more complex integration needs. Integrations from BRPM to JIRA can be found in the [JIRA module](https://github.com/BMC-RLM/brpm_module_jira). 

## Getting started
The integration is done with webhooks: we will set up a tiny HTTP server that listens on a certain mount point (in this case "webhooks") and have JIRA send its notifications as POSTs to this server. The process_webhook_events.rb script will then take action based on the contents of the notifications.

### Running the webhook receiver
The process_webhook_event.rb script should be used with a [webhook_receiver wrapper](https://github.com/BMC-RLM/brpm_content_framework/blob/master/infrastructure/scripts/run_webhook_receiver.sh). Set the environment variable ```WEBHOOK_RECEIVER_PROCESS_EVENT_SCRIPT``` inside the wrapper to the location of this script and execute it in daemon mode: ```nohup ./run_webhook_receiver.sh &```

### Configuring the webhook in JIRA
- First of all make sure that your projects in JIRA have exactly the same name as your applications in BRPM.
 
- Create a WebHook (in System > Advanced > WebHooks) and set the url to http://your-server:port/webhooks (you can tweak the other fields to your specific needs as it's all quite self-explanatory, just make sure to "include the details" of the issues)

### Creating an issue in JIRA
Voila, we're all set. Now create a change request in ServiceNow and see how it triggers a request in BRPM!



