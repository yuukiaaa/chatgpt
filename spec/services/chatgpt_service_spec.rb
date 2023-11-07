require 'rails_helper'
require 'webmock/rspec'

require 'net/http'
require 'json'

RSpec.describe ChatgptService do
  let(:api_key){'api_key'}
  let(:message){'message from user'}
  let(:model){'gpt-3.5-turbo'}
  let(:api_url){'https://api.openai.com/v1/chat/completions'}
  let(:response_body){ JSON.generate({
    "id": "chatcmpl-123",
    "object": "chat.completion",
    "created": 1677652288,
    "choices": [{
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "\n\nHello there, how may I assist you today?",
      },
      "finish_reason": "stop"
    }],
    "usage": {
      "prompt_tokens": 9,
      "completion_tokens": 12,
      "total_tokens": 21
    }
  }) }
  let(:post_body){JSON.generate({
    "model": model,
    "messages": [{"role": "system", "content": ""},  {"role": "user", "content": "Hello!"}],
  })}
  let(:post_header){{
    'Content-Type': 'application/json',
    'Authorization': 'Bearer #{api_key}'
  }}


  let(:chatgpt){described_class.new(message, model)}
    
  describe '#call' do

    # before do
    #   http_mock = double('Net::HTTP')
    #   http_response_mock = double('Net::HTTPResponse', body: response_body)
    #   allow(Net::HTTP).to receive(:start).and_return(http_mock)
    #   allow(http_mock).to receive(:post).with(
    #     URI('https://api.openai.com/v1/chat/completions'),
    #     post_body,
    #     post_header
    #   ).and_return(http_response_mock)
    #   service = described_class.new(message, model)
    #   response = service.send(:call)
    # end

    # it 'HTTPレスポンスを貰えていること' do
    #   expect(response).to eq http_response_mock
    # end

    # it 'レスポンスボディにAPIからのメッセージが格納されていること' do
    #   body_hash = JSON.parse(response.body)
    #   msg = body_hash['choices'][0]['message']['content']
    #   expect(msg).not_to be_empty
    # end

    before(:example) do
      stub_request(:post, api_url).to_return(
        body: response_body, 
        status: 200,
        headers: {'Content-Type': 'application/json'}  
      )
    end

    it 'APIにアクセスできていること' do
      response = chatgpt.send(:call)
      expect{response}.not_to raise_error
    end

    it 'レスポンスボディを返していること' do
      body = chatgpt.send(:call).body
      expect(body).not_to be_empty
    end
  end

  describe '#message' do 
    before(:example) do
      response = double('ChatgptService.call')
      allow(response).to receive(:body).and_return(response_body)
      expect(chatgpt).to receive(:call).and_return(response)
    end

    it 'エラーにならないこと'do
      expect{chatgpt.message}.not_to raise_error
    end

    it '空ではないこと' do
      expect(chatgpt.message).not_to be_empty
    end

  end

end