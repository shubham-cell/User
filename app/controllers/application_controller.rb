class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  TOKEN_TIMEOUT = 1.hour

  before_action :check_token_timeout
  before_action :refresh_token_activity

  helper_method :current_user, :logged_in?, :session_timeout_seconds

  # Bearer token via Warden (Authorization: Bearer <token>)
  def current_user
    @current_user ||= warden.authenticate(:token_authenticatable, store: false)
  end

  # --- Session-based auth (kept for future use) ---
  # def current_user
  #   @current_user ||= NewUser.find_by(id: session[:user_id]) if session[:user_id]
  # end

  # --- Cookie-token auth (previous approach, kept for reference) ---
  # def current_user
  #   @current_user ||= warden.authenticate(:token_authenticatable, store: false)
  # end
  # Cookie was read inside the Warden strategy from cookies.encrypted[:auth_token]

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    respond_to do |format|
      format.html do
        flash[:alert] = "You must be logged in to access this page"
        redirect_to login_path
      end
      format.json { render json: { error: "Unauthorized" }, status: :unauthorized }
    end
  end

  def session_timeout_seconds
    TOKEN_TIMEOUT.to_i
  end

  private

  def warden
    request.env["warden"]
  end

  # Issues a new Bearer token for the user (client must send it as Authorization header).
  def issue_auth_token!(user)
    user.regenerate_authentication_token!
    # Clear any leftover auth cookie from the older cookie-based approach
    cookies.delete(:auth_token)
    warden.set_user(user, scope: :default, store: false)
    user.authentication_token
  end

  def clear_auth_token!(user = current_user)
    user&.clear_authentication_token!
    cookies.delete(:auth_token)
    warden.logout
    @current_user = nil
  end

  def check_token_timeout
    user = current_user
    return if user.blank?
    return unless user.token_expired?(TOKEN_TIMEOUT)

    clear_auth_token!(user)
    respond_to do |format|
      format.html do
        flash[:alert] = "Your session expired after 1 hour of inactivity. Please log in again."
        redirect_to login_path
      end
      format.json { render json: { error: "Token expired" }, status: :unauthorized }
    end
  end

  def refresh_token_activity
    return if performed?
    return unless logged_in?

    current_user.touch_token_activity!
  end

  # --- Session-based timeout (kept for future use) ---
  # SESSION_TIMEOUT = 1.hour
  #
  # before_action :check_session_timeout
  # before_action :refresh_session_activity
  #
  # def check_session_timeout
  #   return if session[:user_id].blank?
  #
  #   last_seen_at = session[:last_seen_at]
  #   return if last_seen_at.blank?
  #
  #   last_seen = Time.zone.parse(last_seen_at.to_s)
  #   return if last_seen >= SESSION_TIMEOUT.ago
  #
  #   reset_session
  #   flash[:alert] = "Your session expired after 1 hour of inactivity. Please log in again."
  #   redirect_to login_path
  # end
  #
  # def refresh_session_activity
  #   return if session[:user_id].blank?
  #
  #   session[:last_seen_at] = Time.current.iso8601
  # end
end
