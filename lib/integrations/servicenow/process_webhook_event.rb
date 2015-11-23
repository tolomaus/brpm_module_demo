BrpmAuto.require_module "brpm_module_brpm"

def process_event(event)
  BrpmAuto.log "Processing event #{event["id"]} ..."

  @brpm_rest_client = BrpmRestClient.new("http://#{ENV["WEBHOOK_RECEIVER_BRPM_HOST"]}:#{ENV["WEBHOOK_RECEIVER_BRPM_PORT"]}/brpm", ENV["WEBHOOK_RECEIVER_BRPM_TOKEN"])

  change_request = event["change_request"]

  request = @brpm_rest_client.create_request(change_request["automation_type"], "#{change_request["automation_type"]} #{change_request["number"]}","Production",false)

  request_to_update = {}
  request_to_update["id"] = request["id"]
  request_to_update["servers"] = [ change_request["configuration_item"] ]

  @brpm_rest_client.update_request_from_hash(request)

  BrpmAuto.log "Finished processing the event."
end
