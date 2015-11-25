# Service-Now to BRPM integration
## Getting started
### Running the webhook receiver as a daemon
This script should be used with a [webhook_receiver wrapper](https://github.com/BMC-RLM/brpm_content_framework/blob/master/infrastructure/scripts/run_webhook_receiver.sh). Set the environment variable ```WEBHOOK_RECEIVER_PROCESS_EVENT_SCRIPT``` to the location of this script and execute it in daemon mode: ```nohup ./run_webhook_receiver.sh &```

### Configuring Service-Now
- Create an outbound REST Message and set the endpoint to http://your-server:port/webhooks (only the POST HTTP method is needed so you may delete the others)

- In the POST HTTP method, specify the content you want to send to the process_webhook_receiver.rb script. in json format

- Copy the generated javascript code from the "Preview Script Usage" link
 
- Create a business rule and have it trigger after a change request is created

- Pass it the generated javascript code and adapt the field values to the change request's field 

As an example of a javascript:
```
function onAfter(current, previous) {
	try {
		var r = new sn_ws.RESTMessageV2('BRPM', 'post');
		r.setStringParameter('number', current.number);
		r.setStringParameter('automation_type', current.u_choice_automation_type);
		r.setStringParameter('cmdb_ci', current.cmdb_ci);
		var response = r.execute();
		var responseBody = response.getBody();
		var httpStatus = response.getStatusCode();
	}
	catch(ex) {
		var message = ex.getMessage();
	}
	
}
```



