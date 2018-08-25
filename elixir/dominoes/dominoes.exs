defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  @doc """
  normalizes dominoes list. Remove duplicates of doubled stones
  and sorts all the stones
  """
  def norm(dominoes) do
    # xs double stones, ys not double stones
    {doubled, rest} = Enum.split_with(dominoes, fn {a, b} -> a == b end)
    sorted_rest = rest
      |> Enum.map(fn 
        {a, b} when a <= b -> {a, b}
        {a, b} -> {b, a}
      end)
      |> Enum.sort_by(&(elem(&1, 0)))
    {sorted_rest, doubled |> Enum.uniq}
  end

  defp update(nil), do: {nil, 1}
  defp update(n),   do: {n, n + 1}

  defp update_sol(sol, {a, b}) do
    {v0, sol1} = Map.get_and_update(sol, a, &update/1)
    {_, sol2}  = Map.get_and_update(sol1, b, &update/1)
    {v0 != nil, sol2}
  end

  defp _chain?([], sol, doubles) when length(doubles) == 1 and sol == %{}, do: true
  defp _chain?([], sol, doubles) do 
    l = sol 
      |> Enum.filter(fn({_, b}) ->  rem(b,2) != 0 end)
      |> length
    (doubles |> Enum.all?(&(Map.has_key?(sol, elem(&1, 0)))) ) &&  l == 0
  end
  defp _chain?([x|xs], sol, doubles) do
    case update_sol(sol, x) do
      {false, _}  -> false
      {true, sol} -> _chain?(xs, sol, doubles)
    end
  end

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?(dominoes) do
    case norm(dominoes) do
      {[], []}          -> true
      {[], doubles}     -> _chain?([], %{}, doubles)
      {[x|xs], doubles} -> 
        {_, sol} = update_sol(%{}, x)
        _chain?(xs, sol, doubles)
    end
  end
end
