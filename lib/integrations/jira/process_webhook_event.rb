BrpmAuto.require_module "brpm_module_brpm"
require_relative "../../jira_mappings"

def process_event(event)
  BrpmAuto.log "Processing event #{event["id"]} ..."

  @brpm_rest_client = BrpmRestClient.new("http://#{ENV["WEBHOOK_RECEIVER_BRPM_HOST"]}:#{ENV["WEBHOOK_RECEIVER_BRPM_PORT"]}/brpm", ENV["WEBHOOK_RECEIVER_BRPM_TOKEN"])

  issue = event["issue"]

  BrpmAuto.log "Validating the issue..."
  unless is_issue_valid(issue)
    raise "Validation error, see the log file for more information."
  end

  # Prepare the ticket placeholder we will use to create or update the ticket
  ticket = {}
  ticket["project_server_id"] = ENV["WEBHOOK_RECEIVER_INTEGRATION_ID"]

  BrpmAuto.log "Associating the ticket with a plan..."
  if issue["fields"]["customfield_#{ENV["WEBHOOK_RECEIVER_JIRA_RELEASE_FIELD_ID"]}"]
    plan = @brpm_rest_client.get_plan_by_name(issue["fields"]["customfield_#{ENV["WEBHOOK_RECEIVER_JIRA_RELEASE_FIELD_ID"]}"]["value"])
    ticket["plan_ids"] = [ plan["id"] ] unless plan.nil?
  end

  BrpmAuto.log "Mapping the issue to the ticket..."
  map_issue_to_ticket(issue, ticket)

  BrpmAuto.log "Creating or updating the ticket..."
  @brpm_rest_client.create_or_update_ticket(ticket)

  BrpmAuto.log "Finished processing the event."
end
