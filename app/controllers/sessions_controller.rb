class SessionsController < ApplicationController
    def create
      user = NewUser.find_by(email: params[:email], password: params[:password])
      if user
        session[:user_id] = user.id
        flash[:notice] = "Logged in successfully!"
        redirect_to profile_path  # Redirect to the user's profile page
      else
        flash[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    end
  
    def destroy
      session[:user_id] = nil
      flash[:notice] = "Logged out successfully"
      redirect_to login_path
    end
  end
  