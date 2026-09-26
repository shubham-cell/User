class TransactionsController < ApplicationController
  before_action :require_login
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  before_action :set_budget, only: [:index]
  before_action :set_user

  def index
    @transactions = current_user.transactions.order(created_at: :desc)
    @budget_amount = current_user.budget&.amount.to_f
    @remaining_balance = current_user.balance_amount&.amount.to_f
    @credit_total = @transactions.select { |t| t.transaction_category.to_i.zero? }.sum { |t| t.amount.to_f }
    @debit_total = @transactions.reject { |t| t.transaction_category.to_i.zero? }.sum { |t| t.amount.to_f }
    @transaction_count = @transactions.size
    spent = [@budget_amount - @remaining_balance, 0].max
    @budget_used_percent = @budget_amount.positive? ? ((spent / @budget_amount) * 100).round(1) : 0

    respond_to do |format|
      format.html
      format.json { render json: @transactions }
    end
  end

  def show
  end

  def new
    @transaction = Transaction.new
  end

  def edit
  end

  def create
    @transaction = @user.transactions.new(transaction_params)
    if @transaction.save
      redirect_to transactions_path, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully destroyed."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :transaction_category)
  end

  def set_budget
    @budget = current_user.budget
    redirect_to new_budget_path, alert: "Please create a budget first" if @budget.nil?
  end

  def set_user
    @user = current_user
  end
end
