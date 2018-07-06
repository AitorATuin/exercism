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
  defp bits_stream(),
    do:
      Stream.resource(
        fn -> 1 end,
        &{[&1], &1 <<< 1},
        & &1
      )

  defp stream(flags) do
    Stream.zip(bits_stream(), Stream.cycle(@allergens))
    |> Enum.take(8)
    |> Enum.filter(fn {b, a} -> (flags &&& b) === b end)
    |> Enum.map(&elem(&1, 1))
  end

  @doc """
  List the allergies for which the corresponding flag bit is true.
  """
  @spec list(non_neg_integer) :: [String.t()]
  def list(flags), do: stream(flags) |> Enum.to_list()

  @doc """
  Returns whether the corresponding flag bit in 'flags' is set for the item.
  """
  @spec allergic_to?(non_neg_integer, String.t()) :: boolean
  def allergic_to?(flags, item), do: list(flags) |> Enum.any?(&(&1 === item))
end
