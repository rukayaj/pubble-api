class DreamstimeService
  include HTTParty
  BASE_URI = 'http://www.dreamstime.com/api/'
  JSON_HEADERS = {'Content-Type' => 'application/json'}
  @@auth_token = ''

  def auth
    body = {'APIRequests': {'Authenticate': {'Verb': 'Authenticate', 'ApplicationId': 'WP-Plugin v2.0'}}}
    response = HTTParty.post(BASE_URI, body: body.to_json, headers: JSON_HEADERS) 
    @@auth_token = response['APIResponses']['Authenticate']['AuthToken']
  end

  def populate_thumbnail_and_copyright(artwork)
    body = {'APIRequests': {'GetPaidImage': {'Verb': 'GetPaidImage', 'ImageId': artwork.source_id, 'AuthToken': @@auth_token}}}
    response = HTTParty.post(BASE_URI, body: body.to_json, headers: JSON_HEADERS) 
    response_obj = JSON.parse(response.body)
   
    # If the auth token is stale, refresh it and re-run the query. TODO find a nicer way of doing this 
    if response_obj['Status'] == 'Error' && (response_obj['ErrorCode'] == 201 || response_obj['ErrorCode'] == 200)
      self.auth
      body = {'APIRequests': {'GetPaidImage': {'Verb': 'GetPaidImage', 'ImageId': artwork.source_id, 'AuthToken': @@auth_token}}}
      response = HTTParty.post(BASE_URI, body: body.to_json, headers: JSON_HEADERS) 
      response_obj = JSON.parse(response.body)
    end

    image_object = JSON.parse(response.body)['APIResponses']['GetPaidImage']['Image']
    artwork.thumbnail_url = image_object['ThumbnailUrl']
    artwork.copyright = image_object['Author']
    artwork
  end 
end
