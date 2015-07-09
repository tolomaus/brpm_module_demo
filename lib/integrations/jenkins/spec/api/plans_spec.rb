require_relative "../spec_helper"

plan_id = nil

describe '/api/plans' do
  before(:all) do
    setup
  end

  it 'should _create_ a plan from a plan template with associated stages and request templates' do
    plan = {}
    plan["name"] = "#{Time.now.strftime("%Y%m%d%H%M%S")} - rest_api_test_plan_from_template"
    plan["plan_template_name"] = "rest_api_test_plan_template"
    plan["deployment_coordinator_id"] = ADMIN_USER_ID
    plan["environment"] = "aws_cloud"
    plan["app_ids"] = [SMARTRELEASE_APP_ID]

    result = brpm_post "v1/plans", { :plan => plan}

    result["code"].should eq(201)

    plan_id = result["response"]["id"]
  end

  it 'should _plan_ a plan from a plan template with associated stages and request templates' do
    plan = {}
    plan["aasm_event"] = "plan_it"

    result = brpm_put "v1/plans/#{plan_id}", { :plan => plan}

    result["code"].should eq(202)
  end

  it 'should _start_ a plan from a plan template with associated stages and request templates' do
    plan = {}
    plan["aasm_event"] = "start"

    result = brpm_put "v1/plans/#{plan_id}", { :plan => plan}

    result["code"].should eq(202)
  end

  it 'should start all requests from the plan' do
    result = brpm_get "v1/plans/#{plan_id}"

    result["code"].should eq(200)

    plan = result["response"]
    plan["members"].each do |member|
      if member.has_key?("request")
        request_id = member["request"]["number"].to_i - 1000

        request_data = {}
        request_data["aasm_event"] = "plan_it"

        result = brpm_put "v1/requests/#{request_id}", { :request => request_data}

        result["code"].should eq(202)

        request_data = {}
        request_data["aasm_event"] = "start"

        result = brpm_put "v1/requests/#{request_id}", { :request => request_data}

        result["code"].should eq(202)
      end
    end
  end
end