BrpmAuto.require_module "brpm_module_brpm"

def process_event(event)
  BrpmAuto.log "Processing event #{event["id"]} ..."

  @brpm_rest_client = BrpmRestClient.new("http://#{ENV["WEBHOOK_RECEIVER_BRPM_HOST"]}:#{ENV["WEBHOOK_RECEIVER_BRPM_PORT"]}/brpm", ENV["WEBHOOK_RECEIVER_BRPM_TOKEN"])

  change_request = event["change_request"]

  request_params = {}
  request_params["change_request_id"] = change_request["id"]
  request_params["change_request_number"] = change_request["number"]
  request_params["target_path_or_servers"] = change_request["cmdb_ci"]

  @brpm_rest_client.create_request("[Template] Self Service - #{change_request["automation_type"]}", "Self Service - #{change_request["automation_type"]} - #{change_request["number"]}","Production", true, request_params)

  BrpmAuto.log "Finished processing the event."
end
