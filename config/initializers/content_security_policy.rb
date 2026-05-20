# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri :self
    policy.object_src :none
    policy.frame_ancestors :none
    policy.form_action :self
    policy.img_src :self, :https, :data
    policy.font_src :self, :https, :data, "https://fonts.gstatic.com"
    policy.style_src :self, :https, "https://fonts.googleapis.com"
    policy.script_src :self, :https
    policy.connect_src :self, :https
  end

  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w(script-src style-src)
end
