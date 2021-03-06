module AuthenticationModule
  mattr_accessor :login_regex, :bad_login_message, 
    :name_regex, :bad_name_message,
    :email_name_regex, :domain_head_regex, :domain_tld_regex, :email_regex, :bad_email_message

  self.login_regex       = /\A\w[\w\.\-_@]+\z/                     # ASCII, strict
  # self.login_regex       = /\A[[:alnum:]][[:alnum:]\.\-_@]+\z/     # Unicode, strict
  # self.login_regex       = /\A[^[:cntrl:]\\<>\/&]*\z/              # Unicode, permissive

  self.bad_login_message = "puoi utilizzare solo lettere, numeri e .-_@".freeze

  self.name_regex        = /^[a-zA-Z][a-zA-Z\-' ]*[a-zA-Z ]$/
  self.bad_name_message  = "Formato del nome non valido.".freeze

  self.email_name_regex  = '[\w\.%\+\-]+'.freeze
  self.domain_head_regex = '(?:[A-Z0-9\-]+\.)+'.freeze
  self.domain_tld_regex  = '(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|it|name|aero|jobs|museum)'.freeze
  self.email_regex       = /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i
  self.bad_email_message = "indirizzo email non valido".freeze

  def self.included(recipient)
    recipient.extend(ModelClassMethods)
    recipient.class_eval do
      include ModelInstanceMethods
    end
  end

  module ModelClassMethods
    def secure_digest(*args)
      Digest::SHA1.hexdigest(args.flatten.join('--'))
    end

    def make_token
      secure_digest(Time.now, (1..10).map{ rand.to_s })
    end
  end # class methods

  module ModelInstanceMethods
  end # instance methods
end
