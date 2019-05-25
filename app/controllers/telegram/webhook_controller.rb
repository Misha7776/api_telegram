class Telegram::WebhookController < Telegram::Bot::UpdatesController
  def start!(*)
    response = from ? "Hello #{from['username']}!" : 'Hi there!'
    respond_with :message, text: response
  end
end
