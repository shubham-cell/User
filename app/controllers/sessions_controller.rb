class SessionsController < ApplicationController
  skip_before_action :check_token_timeout, only: [:create]
  skip_before_action :refresh_token_activity, only: [:new, :create]

  def new
  end

  def create
    user = NewUser.find_by(email: params[:email], password: params[:password])
    if user
      # --- Session-based login (kept for future use) ---
      # reset_session
      # session[:user_id] = user.id
      # session[:last_seen_at] = Time.current.iso8601

      token = issue_auth_token!(user)

      respond_to do |format|
        format.html do
          flash[:notice] = "Logged in successfully!"
          redirect_to profile_path
        end
        format.json do
          render json: {
            token: token,
            token_type: "Bearer",
            expires_in: session_timeout_seconds,
            redirect_url: profile_path,
            user: { id: user.id, name: user.name, email: user.email }
          }, status: :ok
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:alert] = "Invalid email or password"
          render :new, status: :unprocessable_entity
        end
        format.json { render json: { error: "Invalid email or password" }, status: :unauthorized }
      end
    end
  end

  def destroy
    clear_auth_token!

    # --- Session-based logout (kept for future use) ---
    # reset_session

    respond_to do |format|
      format.html do
        if params[:reason] == "idle"
          flash[:alert] = "Your session closed after 1 hour of inactivity. Please log in again."
        else
          flash[:notice] = "Logged out successfully"
        end
        redirect_to login_path
      end
      format.json { render json: { message: "Logged out successfully" }, status: :ok }
    end
  end
end
