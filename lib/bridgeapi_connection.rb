require 'base64'
require 'openssl'
require 'net/http'

# call this function with the specific endpoint to hit
# we can change this in the future to take in more options later
def hit_api_endpoint(endpoint)
  # Authentication info, don't share this!
  pass = SETTINGS[:stugov_api_user]
  priv = SETTINGS[:stugov_api_pass]

  # Our base URL hosted on stugov's server
  base_url = SETTINGS[:stugov_api_base_url]

  # We make a sha256 hash of this in binary format, then base64 encode that
  digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), priv, pass)).chomp

  # Specify which endpoint we'd like to request from. If you want a specific
  #   id from this endpoint, just do <endpoint>/<id>, for example: events/105
  resource = endpoint

  # Any optional parameters that are listed for this endpoint in the API docs
  optional_params = "&page=1"

  # Now we construct the full url
  url = URI.parse("#{base_url}?resource=#{resource}#{optional_params}")

  # Create our request object and set the Authentication header with our encrypted data
  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true
  https.verify_mode = OpenSSL::SSL::VERIFY_NONE

  # Make our request object with Auth field
  req = Net::HTTP::Get.new(url.to_s)
  req.add_field("Authentication", digest)

  # Send the request, put response into res

  # FIRXME handle errors
  res = https.request(req)

  # Output result
  return JSON.parse(res.body)
end
