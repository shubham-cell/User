class TransactionsController < ApplicationController
    before_action :set_transaction, only: [:show, :edit, :update, :destroy]

    # GET /transactions
    def index
        @transactions = Transaction.all
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
        user = NewUser.find(params[:new_user_id])
        if user.transactions.create(transaction_params)
            redirect_to @transaction, notice: 'Transaction was successfully created.'
        else
            render :new
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
            params.require(:transaction).permit(:attribute1, :attribute2, :attribute3) # Replace with actual attributes
        end
end