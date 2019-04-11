defmodule FinancialSystem.Transfer do
  @moduledoc """
  Documentation for Transfer Module.
  """

  defstruct [:money, :date]

  @typedoc "Custom type to represent transfers."
  @type t :: %__MODULE__{         
    date: NaiveDateTime.t(),
    money: Money.t()
  }

  @doc """
  Basic function to create a new transfer, usually used inside other 
  functions to add the transfer to the account transfers history.

  ## Examples
      > FinancialSystem.Transfer.create(Money.new(1000, :BRL)
      {:ok, {%Money{amount: 1000, currency: :BRL}, ~N[2019-04-10 16:19:30.743880]}}
  """
  @spec create(Money.t()) :: {:ok, t} | {:error, String.t()} 
  def create(money) do
    unless is_integer(money.amount), do: raise(ArgumentError, message: "Amount must be an Integer") 
    {:ok, {money, NaiveDateTime.utc_now()}}
  end
end