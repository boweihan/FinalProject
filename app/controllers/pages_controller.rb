class PagesController < ApplicationController
  before_action :load_client

  def load_client
    client_secrets = Google::APIClient::ClientSecrets.load
    @auth_client = client_secrets.to_authorization
    @auth_client.update!(
      :scope => 'https://www.googleapis.com/auth/userinfo.email ' +
      'https://www.googleapis.com/auth/userinfo.profile '+
      'https://www.googleapis.com/auth/gmail.readonly '+
      'https://www.googleapis.com/auth/gmail.send',
      :redirect_uri => 'http://localhost:3000/callback'
      )
  end


  def googleauth
      auth_uri = @auth_client.authorization_uri.to_s
      redirect_to auth_uri
  end

  def callback
    #if user clicks deny
    if params[:error]
      puts "error"

    elsif params[:code]
      #client accepted scopes. use authorization code in qs
      @auth_client.code = params[:code]
      #exchange auth for token
      @auth_client.fetch_access_token!
      current_user.update_all({access_token: @auth_client.token, refresh_token: @auth_client.refresh_token})
    end
    redirect_to '/newsfeed'
  end

  def newsfeed
    #write the loop to grab all the messages of all the contacts with current user
    puts current_user.id
    puts Contact.all
    puts Message.all

    @messages = Array.new
    @contacts = Array.new
    current_user.messages.each do |message|
      @contacts << Contact.find(message.contact_id)
      @messages << message
    end


    #give the newsfeed the ability to send gmail messages
    # gmail_send_url = "https://www.googleapis.com/upload/gmail/v1/users/#{current_user.google_id}/messages/send?uploadType=media&access_token=#{current_user.access_token}"
    #
    # obj = RestClient.post(gmail_send_url,
    #                       {Host: 'www.googleapis.com', contentType: 'message/rfc822'},
    #                       raw: "Q29udGVudC1UeXBlOiB0ZXh0L3BsYWluOyBjaGFyc2V0PSJ1cy1hc2NpaSINCk1JTUUtVmVyc2lvbjogMS4wDQpDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA3Yml0DQp0bzogYnJ5Y2VAdGhvcm1lZGlhLmNvbQ0KZnJvbTogYnJ5Y2VAdGhvcm1lZGlhLmNvbQ0Kc3ViamVjdDogVGVzdA0KDQpIZWxsbyE=")
    # @sent_message = JSON.parse(obj)

  end

  def landing
  end

end
