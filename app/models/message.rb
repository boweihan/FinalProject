class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user

  def self.api
    #this method needs to assign user_id, contact_id, and parameters to a new message object and save it
  end

  def self.send_email(sender, receiver, subj, bod, current_user)
    user_input = Mail.new do
      # from 'Bowei Han <bowei.han100@gmail.com>'
      # to 'Carol Yao <carolyaoo@gmail.com>'
      # subject 'this is a test'
      # body 'hello, hello, is it possible? Could this actually work?'
      from sender
      to receiver
      subject subj
      body bod
    end
    # enc = Base64.encode64(user_input)
    # enc = enc.gsub("+", "-").gsub("/","_")
    message = Google::Apis::GmailV1::Message.new
    message.raw = user_input.to_s
    service = Google::Apis::GmailV1::GmailService.new
    # need to add refresh token here
    service.request_options.authorization = current_user.access_token
    service.send_user_message(current_user.google_id, message_object = message)
  end

end
