require 'spec_helper'

describe SlackNotifier do
  let(:payload) {
    {
        :text => 'Hello World',
        :username => 'fulcrum',
        :icon_emoji => ':ghost:'
    }
  }
  before do
    Configuration.for('fulcrum') do
      slack_webhook_url "/hello"
    end
  end
  it "should send the notifcation to slack" do
    HTTPClient.any_instance.stub(:post) do |arg1, arg2|
      arg1.should == Fulcrum::Application.config.fulcrum.slack_webhook_url
      arg2.should == { :payload => payload.to_json }
      true
    end
    SlackNotifier.notify(payload[:text])
  end
end
