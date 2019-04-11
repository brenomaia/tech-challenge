defmodule TransferTest do
  use ExUnit.Case
  doctest FinancialSystem.Transfer
  
  setup_all do 
    {
      :ok,
      [
        account_a: FinancialSystem.Account.create("Lucas Almeida", "lucasalmeida35@gmail.com", Money.new(1000, :BRL))
      ]
    }
  end
  
  test "User shouldn't be able to create a transfer with invalid amount" do
    assert_raise FunctionClauseError, fn -> 
      FinancialSystem.Transfer.create(Money.new(1000.5, :USD)) 
    end
  end

  test "User shouldn't be able to create a transfer with invalid currency" do
    assert_raise ArgumentError, fn -> 
      FinancialSystem.Transfer.create(Money.new(1000, :USDD)) 
    end
  end
end