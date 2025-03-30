class NewUsersController < ApplicationController
    before_action :require_login, only: [:show]

    def new
        @new_user = NewUser.new  # Use @new_user to match the view
    end

    def show
        @user = current_user
        @budget = @user.budget # Assuming one budget per user
        if @budget.present?
          redirect_to transactions_path # Redirect to the transaction page
        else
          @budget = Budget.new # If no budget, show the budget creation form
        end
    end
      

    def create
        @new_user = NewUser.new(user_params)
        if @new_user.save
            flash[:notice] = "User successfully created!"
            redirect_to new_new_user_path  # Redirecting to the same form page
        else
            flash[:alert] = "Failed to create user. Please try again."
            render :new
        end
    end

    def login
        @user = NewUser.find_by(email: params[:email])
        if @user && @user.authenticate(params[:password])
            render json: @user, status: :ok
        else
            render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def update
        @user = NewUser.find(params[:id])
        if @user.update(user_params)
            render json: @user, status: :ok
        else
            render json: @user.errors, status: :unprocessable_entity
        end
    end

    def destroy
        @user = NewUser.find(params[:id])
        @user.destroy
        head :no_content 
    end


    private

    def user_params
        params.require(:new_user).permit(:name, :email, :password, :password_confirmation)
    end

    def require_login
        unless session[:user_id]
          flash[:alert] = "You must be logged in to access this page"
          redirect_to login_path
        end
      end
    
      def current_user
        @current_user ||= NewUser.find_by(id: session[:user_id])  # Fetch logged-in user
      end
      
end