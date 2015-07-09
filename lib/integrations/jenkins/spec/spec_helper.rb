require_relative "../../../../../modules/framework/brpm_auto"

ADMIN_USER_ID = 1
SMARTRELEASE_APP_ID = 1

def setup
  @brpm_url = "http://#{ENV["BRPM_HOST"]}:#{ENV["BRPM_PORT"]}/brpm"
  @brpm_api_token = ENV["BRPM_API_TOKEN"]

  BrpmAuto.setup( { "output_dir" => "/home/jenkins" } )
end

def add_token(path)
  path + (path.include?("?") ? "&" : "?") + "token=#{@brpm_api_token}"
end

def brpm_get(path, options = {})
  Rest.get("#{@brpm_url}/#{add_token(path)}", options)
end

def brpm_post(path, data, options = {})
  Rest.post("#{@brpm_url}/#{add_token(path)}", data, options)
end

def brpm_put(path, data, options = {})
  Rest.put("#{@brpm_url}/#{add_token(path)}", data, options)
end

def brpm_delete(path, options = {})
  Rest.delete("#{@brpm_url}/#{add_token(path)}", options)
end

setup
