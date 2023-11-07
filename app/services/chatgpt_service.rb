require 'net/http'
require 'uri'
require 'json'

class ChatgptService
  def initialize(message, model='gpt-3.5-turbo')
    @api_key = Rails.application.credentials[:chatgpt][:api_key]
    @api_url = 'https://api.openai.com/v1/chat/completions'
    @model = model
    @system_message = "ユーザからの質問に対して100字以内で誠実に回答すること。"
    @message = message
    @headers =  {
      'Content-Type': 'application/json',
      'Authorization': "Bearer #{@api_key}"
    }
    @body = {
      "model": "gpt-3.5-turbo-0613",
      "messages": [
        {"role": "system", "content": @system_message},
        {"role": "user", "content": @message}
      ]
    }
  end

  def message
    res = call
    message = JSON.parse(res.body)['choices'][0]['message']['content']
    message
  end

  private
  # def call
  #   url = URI.parse(@api_url)

  #   http = Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == 'https')
  #   response = http.post(url.path, JSON.dump(@body), @headers)
  #   http.finish
  #   JSON.parse(response.body)
  # end

  def call
    url = URI.parse(@api_url)

    req = Net::HTTP::Post.new(url, @headers)
    req.body = @body.to_json
    
    req_options = {use_ssl: url.scheme == 'https'}

    response = Net::HTTP.start(url.host, url.port, req_options) do |http|
      http.request(req)
    end
    response
  end

end