class SlackNotifier
  def self.notify(text)
    # story = Story.find(story_id)
    payload = {
        :text => text,
        :username => 'fulcrum',
        :icon_emoji => ":ghost:"
    }
    http = HTTPClient.new
    http.post Fulcrum::Application.config.fulcrum.slack_webhook_url, :payload => payload.to_json
  end
end
