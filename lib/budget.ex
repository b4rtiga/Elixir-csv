defmodule Budget do
  alias NimbleCSV.RFC4180, as: CSV

  def list_transactions do

    File.read!("lib/transactions.csv")
    |> parse
    |> filter
    |> normalize
    |> sort
    |> sum_amounts
    |> print
  end

  defp parse(string) do
    string
    |> String.replace("\r\t", "")
    |> CSV.parse_string
  end

  defp filter(rows) do
    Enum.map(rows, &Enum.drop(&1, 1))
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amount(&1))
  end

  defp parse_amount([date, description, amount]) do
    [date, description, parse_to_float(amount)]
  end

  defp parse_to_float(string) do
    String.to_float(string)
    |> abs
  end

  defp sort(rows) do
    Enum.sort(rows, &sort_asc_by_amount(&1, &2))
  end

  defp sort_asc_by_amount([_, _, prev], [_, _, next]) do
    prev < next
  end

  defp print(rows) do
    IO.puts "\nTransactions:"
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([date, description, amount]) do
    IO.puts "#{date} #{description} \t$#{:erlang.float_to_binary(amount, decimals: 2)}"

  end

  defp sum_amounts(rows) do
    print_sum(Enum.reduce(rows, 0, fn([_, _, a], acc) -> a + acc end))
    rows
  end
  defp print_sum(sum) do
    IO.puts "In Total: #{:erlang.float_to_binary(sum, decimals: 2)}"
  end

end
