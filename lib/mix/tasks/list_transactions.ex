defmodule Mix.Tasks.ListTransactions do
  use Mix.Task

  def run(_) do
    Budget.list_transactions
  end
end
