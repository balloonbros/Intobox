def stub_request_for_dropbox_files_put(send_file_name, state)
  url = "https://api-content.dropbox.com/1/files_put/auto/#{send_file_name}?overwrite=false"
  body = File.read(Rails.root.join("spec/mocks/dropbox/files_put/#{state.to_s}.json"))
  WebMock::API::stub_request(:put, url).to_return(body: body, status: 200)
end

def stub_request_for_dropbox_account(state = :free_space)
  url = 'https://api.dropbox.com/1/account/info'
  body = File.read(Rails.root.join("spec/mocks/dropbox/account/#{state.to_s}.json"))
  WebMock::API::stub_request(:get, url).to_return(body: body, status: 200)
end
