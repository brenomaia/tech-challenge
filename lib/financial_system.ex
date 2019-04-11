defmodule FinancialSystem do
  @moduledoc """
  Documentation for FinancialSystem.
  This is the main module of the project, which enables functions like transference
  between accounts and exchange currency.
  """

  alias Money.Currency, as: Currency
  alias FinancialSystem.Account, as: Account

  @doc """
  Money transfer function from one account to the other.

  ## Examples

      > acc_a =  FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500))
      {...}
      > acc_b =  FinancialSystem.Account.create("acc b", "accb@accb.com", Money.Currency.brl(1600))
      {...}

      > {:ok, acc_a, acc_b} = FinancialSystem.transfer_to_one(acc_a, acc_b, 300) 
      {:ok, %{
          balance: %Money{amount: 1200, currency: :BRL}, email: "acca@acca.com",
          fullname: "acc a",
          transfers: [
            ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 17:26:46.090108]},
            ok: {%Money{amount: -300, currency: :BRL}, ~N[2019-04-10 17:26:55.273526]}
          ]
        },
        %{
          balance: %Money{amount: 1900, currency: :BRL}, email: "accb@accb.com",
          fullname: "acc b",
          transfers: [
            ok: {%Money{amount: 1600, currency: :BRL}, ~N[2019-04-10 17:26:49.930726]},
            ok: {%Money{amount: 300, currency: :BRL}, ~N[2019-04-10 17:26:55.273542]}
          ]
        }
      }
  """
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

  @doc """
  Money transfer function from one account to many others, 
  each one will get a decimal amount until it completes 1.0, 
  according to the other of the accounts and the share proportion.

  ## Examples

      > acc_a =  FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500))
      {...}
      > acc_b =  FinancialSystem.Account.create("acc b", "accb@accb.com", Money.Currency.brl(1600))
      {...}
      > acc_c =  FinancialSystem.Account.create("acc c", "accc@accc.com", Money.Currency.brl(1800))
      {...}

      > {:ok, acc_a, [acc_b, acc_c]} = FinancialSystem.transfer_to_many(acc_a, [acc_b, acc_c], 500, [0.2, 0.8])
      {:ok, %{
          balance: %Money{amount: 1000, currency: :BRL},
          email: "acca@acca.com",
          fullname: "acc a",
          transfers: [
            ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 17:34:01.383288]},
            ok: {%Money{amount: -500, currency: :BRL}, ~N[2019-04-10 17:34:17.781748]}
          ]
        },
        [
          %{
            balance: %Money{amount: 1700, currency: :BRL},
            email: "accb@accb.com",
            fullname: "acc b",
            transfers: [
              ok: {%Money{amount: 1600, currency: :BRL}, ~N[2019-04-10 17:34:06.454048]},
              ok: {%Money{amount: 100, currency: :BRL}, ~N[2019-04-10 17:34:17.781791]}
            ]
          },
          %{
            balance: %Money{amount: 2200, currency: :BRL},
            email: "accc@accc.com",
            fullname: "acc c",
            transfers: [
              ok: {%Money{amount: 1800, currency: :BRL}, ~N[2019-04-10 17:34:11.045920]},
              ok: {%Money{amount: 400, currency: :BRL}, ~N[2019-04-10 17:34:17.781799]}
            ]
          }
        ]      
      }
  """
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

  @doc """
  Auxiliary function to check if all the shares to be multiplied sum 1.0
  """
  @spec check_shares_percentage([Account.t()], [Float.t()]) :: boolean
  def check_shares_percentage(accounts, shares) do
    Enum.count(accounts) == Enum.count(shares) && Enum.sum(shares) == 1.0
  end

  @doc """
  Auxiliary function to pre-check if all the accounts use the same currency.

  ## Examples

      > {:ok, acc_a} =  FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500))
      {:ok, ...}
      > {:ok, acc_b} =  FinancialSystem.Account.create("acc b", "accb@accb.com", Money.Currency.brl(1600))
      {:ok, ...}
      > {:ok, acc_c} =  FinancialSystem.Account.create("acc c", "accc@accc.com", Money.Currency.brl(1800))
      {:ok, ...}
      > list = [acc_a, acc_b, acc_c]
      [...]
      > FinancialSystem.has_same_currency?(list)
      true
  """
  @spec has_same_currency?(List.t()) :: boolean
  def has_same_currency?(accounts) do 
    currency = List.first(accounts).balance.currency
    Enum.all?(accounts, fn(s) -> s.balance.currency == currency end)
  end

  @doc """
  Auxiliary function to check if the account which will be transfered money from
  has enough money to be withdrawn.

  ## Examples
      > {:ok, acc_a} =  FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500))
      {:ok, ...}
      > FinancialSystem.has_enough_balance?(acc_a, 100)
      true
      > FinancialSystem.has_enough_balance?(acc_a, 3000)
      false
  """
  @spec has_enough_balance?(Account.t(), Integer.t()):: boolean 
  def has_enough_balance?(acc, amount) do 
    # Money.compare(acc.balance, Money.new(amount, acc.balance.currency)) == 1
    acc.balance.amount >= amount
  end

  @doc """
  Function to exchange money inside any user account.
  The function withdraws all the money is has avaible and then 
  deposits the same amount as before but in a different currency.

  ## Examples

      > acc = FinancialSystem.Account.create("acc a", "acca@acca.com", Money.Currency.brl(1500))
      {...}
      > acc = FinancialSystem.convert_account(acc, :USD, 0.2613139605)
      %{
        balance: %Money{amount: 392, currency: :USD},
        email: "acca@acca.com",
        fullname: "acc a",
        transfers: [
          ok: {%Money{amount: 1500, currency: :BRL}, ~N[2019-04-10 18:13:58.149649]},
          ok: {%Money{amount: -1500, currency: :BRL}, ~N[2019-04-10 18:14:04.329386]},
          ok: {%Money{amount: 392, currency: :USD}, ~N[2019-04-10 18:14:04.329409]}
        ]
      }
  """
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
