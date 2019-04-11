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

  @spec transfer_to_many(Account.t(), [Account.t()], Integer.t(), [Float.t()]) :: {:ok, Account.t(), [Account.t()]} | {:error, String}
  def transfer_to_many(origin_acc, destination_accs, amount, share_percentage) when is_list(destination_accs) do 

    unless has_same_currency?([origin_acc] ++ destination_accs) do
      {:error, "Your destination account currency must match your source account"}
    end

    unless has_enough_balance?(origin_acc, amount) do
      raise(ArgumentError, message: "You don't have enough money on your origin account")
    end

    unless check_shares_percentage(destination_accs, share_percentage) do
      raise(ArgumentError, message: "You need to have as many shares as destination accounts and they have to sum 1.0")
    end

    {:ok, Account.withdraw(origin_acc, Money.new(amount, origin_acc.balance.currency)), Enum.map(Enum.with_index(destination_accs), fn({r, s}) -> 
      Account.deposit(r, Money.new(round(amount * Enum.at(share_percentage, s)), r.balance.currency))
    end)}

  end

  @spec check_shares_percentage([Account.t()], [Float.t()]) :: boolean
  def check_shares_percentage(accounts, shares) do
    Enum.count(accounts) == Enum.count(shares) && Enum.sum(shares) == 1.0
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
