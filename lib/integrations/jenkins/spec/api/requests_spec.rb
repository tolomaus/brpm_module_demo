require_relative "../spec_helper"

request_id = nil

describe '/api/requests' do
  before(:all) do
    setup
  end

  it 'should create a request' do
    request = {}
    request["name"] = "rest_api_test_request"
    request["requestor_id"] = ADMIN_USER_ID
    request["deployment_coordinator_id"] = ADMIN_USER_ID
    request["environment"] = "aws_cloud"
    request["app_ids"] = [SMARTRELEASE_APP_ID]

    result = brpm_post "v1/requests", { :request => request}

    result["code"].should eq(201)

    request_id = result["response"]["id"]
  end

  it 'should plan a request' do
    request = {}
    request["aasm_event"] = "plan_it"

    result = brpm_put "v1/requests/#{request_id}", { :request => request}

    result["code"].should eq(202)
  end

  it 'should start a request' do
    request = {}
    request["aasm_event"] = "start"

    result = brpm_put "v1/requests/#{request_id}", { :request => request}

    result["code"].should eq(202)
  end

#  it 'should get all the requests' do
#    result = brpm_get "v1/requests"
#
#    result["code"].should eq(200)
#    result["response"].length.should be >= 1
#  end

  it 'should get a request by name' do
    result = brpm_get "v1/requests?filters[name]=rest_api_test_request"

    result["code"].should eq(200)
    result["response"].length.should be >= 1
    result["response"][0]["name"].should eq("rest_api_test_request")
  end
end