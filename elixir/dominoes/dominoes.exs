defmodule Dominoes do
  @type domino :: {1..6, 1..6}

  def stone_value({a, b}) do
    cond do
      a <= b -> a
      true -> b
    end
  end

  @doc """
  normalizes dominoes list. Remove duplicates of doubled stones
  and sorts all the stones
  """
  def norm(dominoes) do
    # xs double stones, ys not double stones
    {xs, ys} = Enum.split_with(dominoes, fn {a, b} -> a == b end)
    (ys
      |> Enum.map(fn 
        {a, b} when a <= b -> {a, b}
        {a, b} -> {b, a}
      end)
      |> Enum.sort_by(&stone_value/1)
    ) ++ (xs |> Enum.uniq)
  end

  def update(nil), do: {nil, 1}
  def update(0), do: {0, 1}
  def update(n), do: {n, n + 1}

  def update_sol(sol, {a, b}) do
    {v0, sol1} = Map.get_and_update(sol, a, &update/1)
    {v1, sol2} = Map.get_and_update(sol1, b, &update/1)
    {v0 != nil, sol2}
  end

  defp _chain?([], sol, []) when sol == %{}, do: true
  defp _chain?([], sol, doubles) when length(doubles) == 1 and sol == %{}, do: true
  defp _chain?([], sol, doubles) when sol == %{}, do: false
  defp _chain?([], sol, doubles) do 
    l = sol 
      |> Enum.filter(fn({_, b}) ->  rem(b,2) != 0 end)
      |> length
    (doubles |> Enum.all?(&(Map.has_key?(sol, elem(&1, 0)))) ) &&  l == 0
  end
  defp _chain?([{a, a} | xs], sol, doubles), do: _chain?(xs, sol, [{a, a}|doubles])
  defp _chain?([x|xs], sol, doubles) do
    case update_sol(sol, x) do
      {false, _} -> false
      {true, sol} -> _chain?(xs, sol, doubles)
    end
    # {v0, sol1} = Map.get_and_update(sol, a, &update/1)
    # {v1, sol2} = Map.get_and_update(sol1, b, &update/1)
    # if !v0 || !v1 do
    #   false
    # else
    #   _chain?(xs, sol2, doubles)
    # end
  end

  @doc """
  chain?/1 takes a list of domino stones and returns boolean indicating if it's
  possible to make a full chain
  """
  @spec chain?(dominoes :: [domino] | []) :: boolean
  def chain?([]), do: true
  def chain?([x|xs]) do
    {_, sol} = update_sol(%{}, x)
    IO.inspect(norm(xs))
    _chain?(norm(xs), sol, [])
  end
end
