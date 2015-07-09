def is_issue_valid(issue)
  return true
end

def map_issue_to_ticket(issue, ticket)
  ticket["foreign_id"] = issue["key"]
  ticket["ticket_type"] = issue["fields"]["issuetype"]["name"]
  ticket["name"] = issue["fields"]["summary"]
  ticket["status"] = issue["fields"]["status"]["name"]
  ticket["app_name"] = issue["fields"]["project"]["name"]

  ticket["extended_attributes_attributes"] = Array.new
#  ticket["extended_attributes_attributes"].push( { "name" => "blabla", "value_text" => "bloblo" } )
end

def map_stage_to_issue_status(stage)
  case stage
    when "Development"
      return "Deployed to development"
    when "Test"
      return "Deployed to test"
    else
      return nil
  end
end


