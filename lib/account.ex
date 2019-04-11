defmodule FinancialSystem.Account do
  @moduledoc """
  Documentation for Account Module.
  """
  
  defstruct [:fullname, :email, :balance, :transfers]

  @type t :: %__MODULE__{
    fullname: String.t(), 
    email: String.t(), 
    balance: Money.t(), 
    transfers: [Transfer.t()]
  }

  alias FinancialSystem.Transfer, as: Transfer

  @spec create(String.t(), String.t(), Money.t()) :: t() | {:error, String.t()}
  def create(fullname, email, balance) do 
    unless is_binary(fullname) && is_binary(email) do
      raise(ArgumentError, message: "Fullname and email must be a String")
    end

    transfer = Transfer.create(balance)
    
    %{fullname: fullname, email: email, balance: balance, transfers: [transfer]}
  end

  @spec withdraw(Account.t(), Money.t()) :: Account.t() | {:error, String.t()}
  def withdraw(account, money) do
    unless money.amount > 0 && money.amount <= account.balance.amount do
      raise(ArgumentError, message: "You need to withdraw an integer equal or lower to current balance")
    end

    transfer = Transfer.create(%Money{amount: - money.amount, currency: money.currency})

    account 
    |> Map.put(:transfers, account.transfers ++ [transfer])
    |> Map.put(:balance, Money.subtract(account.balance, money))
    
  end

  @spec deposit(Account.t(), Money.t()) :: Account.t() | {:error, String.t} 
  def deposit(account, money) do
    unless money.amount > 0 do
      raise(ArgumentError, message: "You need to deposit a value higher than 0")
    end
    
    transfer = Transfer.create(money)

    account 
    |> Map.put(:transfers, account.transfers ++ [transfer])
    |> Map.put(:balance, Money.add(account.balance, money))
  end
end