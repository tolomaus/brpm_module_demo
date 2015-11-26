# ServiceNow to BRPM integration
## Intro
This integration will automatically create a request in BRPM when a change request is created in ServiceNow. This is just a first step in integrating ServiceNow with BRPM. It can easily be extended to cover more complex integration needs. Integrations from BRPM to ServiceNow can be found in the [ServiceNow module](https://github.com/BMC-RLM/brpm_module_servicenow). 

## Getting started
The integration is done with webhooks: we will set up a tiny HTTP server that listens on a certain mount point (in this case "webhooks") and have ServiceNow send its notifications as POSTs to this server. The process_webhook_events.rb script will then take action based on the contents of the notifications.  

### Running the webhook receiver
The process_webhook_event.rb script should be used with a [webhook_receiver wrapper](https://github.com/BMC-RLM/brpm_content_framework/blob/master/infrastructure/scripts/run_webhook_receiver.sh). Set the environment variable ```WEBHOOK_RECEIVER_PROCESS_EVENT_SCRIPT``` inside the wrapper to the location of this script and execute it in daemon mode: ```nohup ./run_webhook_receiver.sh &```

### Creating a request template in BRPM
Create one or more request templates with the name ```[Template] Self Service - <automation type>``` where automation_type can be "Reboot server", etc.

### Configuring ServiceNow
- Create a new dropdown field for a change request with the name u_choice_automation_type and configure a number of choices like "Reboot server" etc.

- Create an outbound REST Message and set the endpoint to http://your-server:port/webhooks (only the POST HTTP method is needed so you may delete the others)

- In the POST HTTP method, specify the content you want to send to the process_webhook_receiver.rb script in json format and create variables substitutions for each of the variables

You can use this content as an example:
```
{"change_request": {"id":"${id}", "number":"${number}", "automation_type":"${automation_type}", "cmdb_ci":"${cmdb_ci}"}}
```

- Copy the generated javascript code from the "Preview Script Usage" link
 
- Create a business rule and have it trigger after a change request is created

- Pass it the generated javascript code and adapt the field values to the change request's field 

As an example of a javascript piece of code:
```
function onAfter(current, previous) {
	try {
		var r = new sn_ws.RESTMessageV2('BRPM', 'post');
		r.setStringParameter('id', current.sys_id);
		r.setStringParameter('number', current.number);
		r.setStringParameter('automation_type', current.u_choice_automation_type);
		r.setStringParameter('cmdb_ci', current.cmdb_ci.getDisplayValue());
		var response = r.execute();
		var responseBody = response.getBody();
		var httpStatus = response.getStatusCode();
	}
	catch(ex) {
		var message = ex.getMessage();
	}	
}
```

### Creating a change request in ServiceNow
Voila, we're all set. Now create a change request in ServiceNow and see how it triggers a request in BRPM!



