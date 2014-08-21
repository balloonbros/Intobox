def stub_request_for_facebook_user(user_body_file, access_token)
  body = File.read(Rails.root.join("spec/mocks/fb_graph/users/#{user_body_file.to_s}.json"))
  user_url = "#{GRAPH_API_URL}/me?access_token=#{access_token}"
  WebMock::API::stub_request(:get, user_url).to_return(body: body, status: 200)

  JSON.parse(body)
end

def stub_request_for_facebook_friends(user_body_file, access_token)
  user = JSON.parse(File.read(Rails.root.join("spec/mocks/fb_graph/users/#{user_body_file.to_s}.json")))
  body = File.read(Rails.root.join("spec/mocks/fb_graph/friends/#{user_body_file.to_s}_friends.json"))
  url = "#{GRAPH_API_URL}/#{user['id']}/friends?access_token=#{access_token}"
  WebMock::API::stub_request(:get, url).to_return(body: body, status: 200)

  JSON.parse(body)
end

def stub_request_for_facebook_friends_by_user_id(user_id, user_body_file, access_token)
  body = File.read(Rails.root.join("spec/mocks/fb_graph/friends/#{user_body_file.to_s}.json"))
  url = "#{GRAPH_API_URL}/#{user_id}/friends?access_token=#{access_token}"
  WebMock::API::stub_request(:get, url).to_return(body: body, status: 200)

  JSON.parse(body)
end
