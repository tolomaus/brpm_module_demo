# JIRA to BRPM integration
## Intro
This integration will automatically synchronize JIRA issues with BRPM tickets when an issue is created, updated or deleted in JIRA. This is just a first step in integrating JIRA with BRPM. It can easily be extended to cover more complex integration needs. Integrations from BRPM to JIRA can be found in the [JIRA module](https://github.com/BMC-RLM/brpm_module_jira). 

## Getting started
The integration is done with webhooks: we will set up a tiny HTTP server that listens on a certain mount point (in this case "webhooks") and have JIRA send its notifications as POSTs to this server. The process_webhook_events.rb script will then take action based on the contents of the notifications.

### Running the webhook receiver
The ```process_webhook_event.rb``` script should be used with a [webhook_receiver](https://github.com/BMC-RLM/brpm_content_framework/blob/master/bin/webhook_receiver). The easiest way to set this up is with a wrapper script like ```run_jira_webhook_receiver.sh``` that sets the necessary environment variables. Copy it to a location of your choice and adapt the environment variables where needed.

Execute the wrapper script in daemon mode: ```nohup /path/to/run_jira_webhook_receiver.sh &```

### Mapping the fields
The mapping between an issue in JIRA and a ticket in BRPM can be configured in the [jira_mappings.rb](https://github.com/BMC-RLM/brpm_module_demo/blob/master/lib/jira_mappings.rb) script. Make sure to restart the webhook receiver after each change to this script.

### Configuring the webhook in JIRA
- First of all make sure that your projects in JIRA have exactly the same name as your applications in BRPM.
 
- Create a WebHook (in System > Advanced > WebHooks) and set the url to http://your-server:port/webhooks. You can tweak the other fields to your specific needs as it's all quite self-explanatory, just make sure to "include the details" of the issues.

### Creating an issue in JIRA
Voila, we're all set. Now create a change request in ServiceNow and see how it triggers a request in BRPM!



