defmodule RotationalCipher do

  defp rotate_char(c, s, b), do: <<b + rem(c - b + s, 26)>>
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(<<c>> <> cs, shift) when (c >= ?a) and (c <= ?z) do
    rotate_char(c, shift, ?a) <> rotate(cs, shift)
  end

  def rotate(<<c>> <> cs, shift) when (c >= ?A) and (c <= ?Z) do
    rotate_char(c, shift, ?A) <> rotate(cs, shift)
  end

  def rotate(<<c>> <> cs, shift), do: <<c>> <> rotate(cs, shift)

  def rotate("", _), do: ""
end
