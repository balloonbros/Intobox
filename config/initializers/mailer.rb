ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  enable_starttls_auto: true,
  address: Rails.application.secrets.mailer.address,
  port: Rails.application.secrets.mailer.address,
  domain: Rails.application.secrets.mailer.domain,
  authentication: Rails.application.secrets.mailer.authentication,
  user_name: Rails.application.secrets.mailer.error.user_name,
  password: Rails.application.secrets.mailer.error.password
}
