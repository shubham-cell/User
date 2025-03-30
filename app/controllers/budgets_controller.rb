class BudgetsController < ApplicationController
    before_action :require_login
  
    def new
      @budget = Budget.new
    end
  
    def create
     @budget = Budget.new(budget_params)
      @budget.new_user_id = current_user.id
      if @budget.save
        flash[:notice] = "Budget successfully created!"
        redirect_to new_transaction_path # Redirecting to transaction creation page
      else
        flash.now[:alert] = "Error creating budget"
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def budget_params
      params.require(:budget).permit(:amount, :budget_category)
    end
  
    def require_login
      redirect_to login_path unless current_user
    end
end