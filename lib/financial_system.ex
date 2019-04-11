defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  """

  alias Money.Currency, as: Currency
  alias FinancialSystem.Account, as: Account

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
