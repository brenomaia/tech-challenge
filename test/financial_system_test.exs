defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  alias FinancialSystem.Account, as: Account

  setup_all do 
    {
      :ok,
      [
        account_a: Account.create("Lucas Almeida", "lucasalmeida35@gmail.com", Money.new(1000, :BRL)),
        account_b: Account.create("Hugo Silva", "hugosilva04@gmail.com", Money.new(1500, :BRL)),
        account_c: Account.create("Luiz Martins", "luizmartins54@gmail.com", Money.new(1000, :BRL)),
        account_d: Account.create("Steve Jones", "stevejones91@gmail.com", Money.new(1000, :USD)),
      ]
    }
  end

  test "User should be able to transfer money to another account", %{
    account_a: origin_acc,
    account_b: destination_acc
  } do

    assert FinancialSystem.transfer_to_one(origin_acc, destination_acc, 100)
  end

  test "User cannot transfer if not enough money available on the account", %{
    account_a: origin_acc,
    account_b: destination_acc
  } do

    assert_raise ArgumentError, fn -> 
      FinancialSystem.transfer_to_one(origin_acc, destination_acc, 5000)
    end
  end

  # Same as previous one, but using transfer_to_many
  test "User cannot transfer to many if not enough money avaible in the account", %{
    account_a: origin_acc ,
    account_b: acc_b,
    account_c: acc_c
  } do

    list = [
      acc_b,
      acc_c
    ]

    assert_raise ArgumentError, fn ->  
      FinancialSystem.transfer_to_many(origin_acc, list, 8000, [0.5, 0.5])
    end
  end

  test "A transfer should be cancelled if an error occurs", %{
    account_a: origin_acc,
    account_d: destination_acc
  } do

    assert_raise ArgumentError, fn -> 
      FinancialSystem.transfer_to_one(
        origin_acc, 
        destination_acc,
        1000)
    end
  end

  test "A transfer can be splitted between 2 or more accounts", %{
    account_a: origin_acc ,
    account_b: acc_b,
    account_c: acc_c
  } do

    list = [
      acc_b,
      acc_c
    ]

    assert FinancialSystem.transfer_to_many(origin_acc, list, 1000, [0.5, 0.5])
  end

  test "User should be able to exchange money between different currencies", %{account_a: account} do
    assert FinancialSystem.convert_account(account, :USD, 0.2597352402)
  end

  test "Currencies should be in compliance with ISO 4217"  do
    assert Money.Currency.exists?(:USD) == true
    assert Money.Currency.exists?(:BRL) == true
    assert Money.Currency.exists?(:NNEE) == false
  end
end
