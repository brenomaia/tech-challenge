defmodule FinancialSystem.Transfer do
  @moduledoc """
  Documentation for Transfer Module.
  """
  defstruct [:money, :date]

  @type t :: %__MODULE__{         
    date: NaiveDateTime.t(),
    money: Money.t()
  }

  @spec create(Money.t()) :: {:ok, t} | {:error, String.t()} 
  def create(money) do
    unless is_integer(money.amount), do: raise(ArgumentError, message: "Amount must be an Integer") 
    {:ok, {money, NaiveDateTime.utc_now()}}
  end
end