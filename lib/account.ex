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
end