class Message < ActiveRecord::Base
  belongs_to :contact
  belongs_to :user

  def self.send_email(sender, receiver, subj, bod, current_user)
    user_input = Mail.new do
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

  def refresh_token_if_expired
  end

  def token_expired?
  end

end
