defmodule FinancialSystem.Account do
  @moduledoc """
  Documentation for Account Module.
  Module that allows us to create Accounts and manipulate them.
  The Examples structure in this is sequential.
  """
  
  defstruct [:fullname, :email, :balance, :transfers]

  @typedoc "Custom Type to represent an account."
  @type t :: %__MODULE__{
    fullname: String.t(), 
    email: String.t(), 
    balance: Money.t(), 
    transfers: [Transfer.t()]
  }

  alias FinancialSystem.Transfer, as: Transfer

  @doc """
  Basic function for account creation
  
  ## Examples

      > acc_a = FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500)) 
      %{balance: %Money{amount: 1500, currency: :BRL}, email: "acca@acca.com", fullname: "acc a",
        transfers: [
          ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 16:23:23.985343]}
        ]
      }
  """
  @spec create(String.t(), String.t(), Money.t()) :: t() | {:error, String.t()}
  def create(fullname, email, balance) do 
    unless is_binary(fullname) && is_binary(email) do
      raise(ArgumentError, message: "Fullname and email must be a String")
    end

    transfer = Transfer.create(balance)
    
    %{fullname: fullname, email: email, balance: balance, transfers: [transfer]}
  end

  @doc """
  Function to withdraw an amount of money from the account balance.
  The money parameter needs to be in the same currency as the accounts.

  ## Examples

      > acc_a = FinancialSystem.Account.withdraw(acc_a, %Money{amount: 50, currency: :BRL}) 
      %{balance: %Money{amount: 1450, currency: :BRL}, email: "acca@acca.com",
        fullname: "acc a",
        transfers: [
          ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 16:55:40.072309]},
          ok: {%Money{amount: -50, currency: :BRL}, ~N[2019-04-10 16:59:15.909202]}
        ]
      }
  """
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

  @doc """
  Function to deposit an amount of money from the account balance.
  The money parameter needs to be in the same currency as the accounts.

  ## Examples

      > acc_a = FinancialSystem.Account.deposit(acc_a, %Money{amount: 150, currency: :BRL})
      %{balance: %Money{amount: 1600, currency: :BRL}, email: "acca@acca.com", fullname: "acc a",
        transfers: [
          ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 16:55:40.072309]},
          ok: {%Money{amount: -50, currency: :BRL}, ~N[2019-04-10 16:59:15.909202]},
          ok: {%Money{amount: 150, currency: :BRL}, ~N[2019-04-10 17:02:39.949160]}
        ]
      }
  """
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