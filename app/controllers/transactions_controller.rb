class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]
    before_action :set_budget, only: [:index]
    before_action :set_user

    # GET /transactions
    def index
        @transactions = current_user.transactions
        respond_to do |format|
        format.html # This will look for index.html.erb (default)
        format.json { render json: @transactions }
        end
    end

    # GET /transactions/1
    def show
    end

    # GET /transactions/new
    def new
        @transaction = Transaction.new
    end

    # GET /transactions/1/edit
    def edit
    end

    # POST /transactions
    def create
        @transaction = @user.transactions.new(transaction_params)
        if @transaction.save
            redirect_to transactions_path, notice: 'Transaction was successfully created.'
        else
            render :new, status: :unprocessable_entity
        end
    end

    # PATCH/PUT /transactions/1
    def update
        if @transaction.update(transaction_params)
            redirect_to @transaction, notice: 'Transaction was successfully updated.'
        else
            render :edit
        end
    end

    # DELETE /transactions/1
    def destroy
        @transaction.destroy
        redirect_to transactions_url, notice: 'Transaction was successfully destroyed.'
    end

    private
        # Use callbacks to share common setup or constraints between actions.
        def set_transaction
            @transaction = Transaction.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def transaction_params
            params.require(:transaction).permit(:amount, :description, :transaction_category) # Replace with actual attributes
        end

        def set_budget
            @budget = current_user.budget
        
            # Redirect to budget creation page if no budget exists
            redirect_to new_budget_path, alert: "Please create a budget first" if @budget.nil?
        end

        def set_user
            @user = current_user
        end
end