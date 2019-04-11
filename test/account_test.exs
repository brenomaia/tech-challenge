defmodule AccountTest do
  use ExUnit.Case
  doctest FinancialSystem.Account

  setup_all do 
    {
      :ok,
      [
        account_a: FinancialSystem.Account.create("Lucas Almeida", "lucasalmeida35@gmail.com", Money.new(1000, :BRL))
      ]
    }
  end

  test "User shouldn't be able to create an account with invalid currency" do
    assert_raise ArgumentError, fn -> 
      FinancialSystem.Account.create("José Valim", "josevalim@elixir.com", Money.new(10_000, :ELX))
    end
  end

  test "User shouldn't be able to deposit in a different currency than his account", %{account_a: account} do
    assert_raise ArgumentError, fn -> 
      FinancialSystem.Account.deposit(account, Money.new(1000, :USD))
    end
  end

  test "User shouldn't be able to withdraw in a different currency than his account", %{account_a: account} do
    assert_raise ArgumentError, fn -> 
      FinancialSystem.Account.withdraw(account, Money.new(1000, :USD))
    end
  end
  
  test "Full name and email must be strings" do
    assert_raise ArgumentError, fn -> FinancialSystem.Account.create(10, 10, Money.new(1000, :BRL)) end
  end

  test "User can't withdraw more than he has on balance", %{account_a: account} do 
    assert_raise ArgumentError, fn -> FinancialSystem.Account.withdraw(account, Money.new(8500, :BRL)) end
  end

  test "User should deposit a value higher than zero", %{account_a: account} do
    assert_raise ArgumentError, fn -> FinancialSystem.Account.deposit(account, Money.new(-9500, :BRL)) end
  end

end