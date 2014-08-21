require 'net/http'
require 'uri'

#
# GrowthForecastに対してデータをPOSTします。
#
# [引数]
#   section グラフのセクション名
#   graph   グラフ名
#   number  グラフデータ
#
def post_to_growthforecast(section, graph, number)
  uri = URI("#{Rails.application.secrets.growth.api_url}/#{Settings.growth.service_name}/#{section}/#{graph}")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data(number: number)
  Rails.logger.info http.request(request).body
end
