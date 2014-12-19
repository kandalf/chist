require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe 'ChistApp::ApiRoutes' do
  before do
    User.dataset.destroy
    Chist.dataset.destroy
    UserApiKey.dataset.destroy

    @user = User.spawn
    UserApiKey.create(:user_id => @user.id, :name => "Default", :key => "1234")
  end

  it 'should create chist from request body' do
    params = {:chist => { :title => "Test", :format => "irc", :chist => "19:22 <nickname> message"}}

    headers = {
      "CONTENT_TYPE" => "application/json",
      "HTTP_ACCEPT" => "application/json",
      "HTTP_AUTHORIZATION" => @user.user_api_keys[0].key
    }

    post "/chists", params.to_json, headers

    
    last_response.status.must_equal 201

    response = JSON.parse(last_response.body)

    last_response["Location"].wont_be_nil
    last_response["Content-type"].must_equal "application/json"

    response["chist"].wont_be_nil
    response["chist"]["url"].wont_be_nil

    last_response["Location"].must_equal response["chist"]["url"]

    @user.chists.first.title.must_equal params[:chist][:title]
    @user.chists.first.format.must_equal params[:chist][:format]
    @user.chists.first.chist_raw.must_equal params[:chist][:chist]

  end
end
