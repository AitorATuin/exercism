defmodule Allergies do
  use Bitwise

  @allergens [
    "eggs",
    "peanuts",
    "shellfish",
    "strawberries",
    "tomatoes",
    "chocolate",
    "pollen",
    "cats"
  ]
  @allergens_len length(@allergens)

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags) do
    bits_list = 0..@allergens_len |> Enum.map(&(1 <<< &1))

    Enum.zip(bits_list, @allergens)
    |> Enum.filter(fn {b, a} -> (flags &&& b) === b end)
    |> Enum.map(&elem(&1, 1))
  end

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item), do: list(flags) |> Enum.any?(&(&1 === item))
end
