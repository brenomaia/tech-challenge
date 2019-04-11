defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  alias Money.Currency, as: Currency
  alias FinancialSystem.Account, as: Account

  @spec transfer_to_one(Account.t(), Account.t(), Integer.t()) ::  {:ok, Account.t(), Account.t()} | {:error, String.t()}
  def transfer_to_one(origin_acc, destination_acc, amount) do

    unless has_same_currency?([origin_acc, destination_acc]) do
      {:error, "Your destination account currency must match your source account"}
    end

    if has_enough_balance?(origin_acc, amount) do
      {:ok, Account.withdraw(origin_acc, Money.new(amount, origin_acc.balance.currency)), 
        Account.deposit(destination_acc, Money.new(amount, origin_acc.balance.currency))}
        
    else 
      raise(ArgumentError, message: "You don't have enough money on your origin account")
    end
  end

  @spec has_same_currency?(List.t()) :: boolean
  def has_same_currency?(accounts) do 
    currency = List.first(accounts).balance.currency
    Enum.all?(accounts, fn(s) -> s.balance.currency == currency end)
  end

  @spec has_enough_balance?(Account.t(), Integer.t()):: boolean 
  def has_enough_balance?(acc, amount) do 
    # Money.compare(acc.balance, Money.new(amount, acc.balance.currency)) == 1
    acc.balance.amount >= amount
  end

  @spec convert_account(Account.t(), Currency.t(), Float.t()) :: Account.t() | {:error, String.t()}
  def convert_account(account, currency, rate) do
    
    unless account.balance.currency != currency do
      raise(ArgumentError, message: "You have to exchange to a diferent currency")
    end

    value =  Money.multiply(account.balance, rate)

    account
    |> Account.withdraw(account.balance)
    |> Map.put(:balance, Money.new(0, currency))
    |> Account.deposit(Money.new(value.amount, currency))
  end
end
