require_relative "../spec_helper"

describe '/api/applications' do
  before(:all) do
    setup
  end

  it 'should create an application' do
    app = {}
    app["name"] = "rest_api_test_app1"

    result = brpm_post "v1/apps", { :app => app}

    result["code"].should eq(201)
  end

  it 'should create another application' do
    app = {}
    app["name"] = "rest_api_test_app2"

    result = brpm_post "v1/apps", { :app => app}

    result["code"].should eq(201)
  end

  it 'should get all the applications' do
    result = brpm_get "v1/apps"

    result["code"].should eq(200)
    result["response"].length.should be >= 6
  end

  it 'should get an application by name' do
    result = brpm_get "v1/apps?filters[name]=rest_api_test_app1"

    result["code"].should eq(200)
    result["response"].length.should eq(1)
    result["response"][0]["name"].should eq("rest_api_test_app1")
  end

  it 'should update an application' do
    result = brpm_get "v1/apps?filters[name]=rest_api_test_app1"

    result["code"].should eq(200)

    app_id = result["response"][0]["id"]

    newname = "#{Time.now.strftime("%Y%m%d%H%M%S")} - rest_api_test_app1"
    app = {}
    app["name"] = newname

    result = brpm_put "v1/apps/#{app_id}", { :app => app}

    result["code"].should eq(202)
    result["response"]["name"].should eq(newname)
  end

  it 'should update another application' do
    result = brpm_get "v1/apps?filters[name]=rest_api_test_app2"

    result["code"].should eq(200)

    app_id = result["response"][0]["id"]

    newname = "#{Time.now.strftime("%Y%m%d%H%M%S")} - rest_api_test_app2"
    app = {}
    app["name"] = newname

    result = brpm_put "v1/apps/#{app_id}", { :app => app}

    result["code"].should eq(202)
    result["response"]["name"].should eq(newname)
  end

  it 'should delete all applications' do
    result = brpm_get "v1/apps"

    result["code"].should eq(200)

    result["response"].each do |app|
      if app["name"] =~ /rest_api_test_app/
        result = brpm_delete "v1/apps/#{app["id"]}"

        result["code"].should eq(202)
      end
    end

  end
end