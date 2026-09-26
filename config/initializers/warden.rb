# frozen_string_literal: true

require Rails.root.join("lib/strategies/token_authenticatable")

Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :token_authenticatable
  manager.intercept_401 = false
  manager.failure_app = lambda do |env|
    request = ActionDispatch::Request.new(env)

    if request.format.json?
      [
        401,
        { "Content-Type" => "application/json" },
        [{ error: "Unauthorized" }.to_json]
      ]
    else
      [
        302,
        { "Location" => "/login", "Content-Type" => "text/html" },
        ["You are being redirected to login"]
      ]
    end
  end
end

# Do not persist the user in the Rack session — token is the source of truth.
Warden::Manager.serialize_into_session(&:id)
Warden::Manager.serialize_from_session do |id|
  NewUser.find_by(id: id)
end
