Configuration.for('fulcrum') do
  # On Heroku, ensure you `heroku config:add APP_HOST=appname.herokuapp.com`
  app_host ENV['APP_HOST'] || '127.0.0.1:3000'

  # The address which system emails will originate from.
  mailer_sender ENV['MAILER_SENDER'] || 'noreply@example.com'

  # Disable registration pages
  disable_registration ENV['DISABLE_REGISTRATION'] || false

  # Admin Email
  admin_email ENV['ADMIN_EMAIL'] || 'admin@example.com'

  # Slack Notifications
  slack_notifications ENV['SLACK_NOTIFICATIONS'] || false
  slack_webhook_url ENV['SLACK_WEBHOOK_URL'] || ''


  # Project column order:
  # progress_to_right: chilly bin, backlog, in progress, done
  # progress_to_left: done, in progress, backlog, chilly bin
  column_order 'progress_to_left'
end
