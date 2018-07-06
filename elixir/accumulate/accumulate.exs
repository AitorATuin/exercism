defmodule Accumulate do
  @doc """
    Given a list and a function, apply the function to each list item and
    replace it with the function's return value.
  """

  @spec accumulate(list, (any -> any)) :: list
  def accumulate([], _), do: []
  def accumulate([x|xs], fun), do: [fun.(x)|accumulate(xs, fun)]
end
