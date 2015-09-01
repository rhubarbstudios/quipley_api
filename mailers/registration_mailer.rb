class RegistrationMailer < SinatraMore::MailerBase

  puts 'runs mailer'

  SinatraMore::MailerBase.smtp_settings = {
    :host   => '127.0.0.1',
    :port   => '1025',
    :tls    => false
  }

  def registration_email(name, merchant)
    from 'noreply@quipley.com'
    # to 'abigail.m.schilling@gmail.com'
    to 'pakrouse@gmail.com'
    subject "#{merchant} has created an event!"
    body    :name => name
    via     :smtp       # optional, to smtp if defined otherwise sendmail
  end
end