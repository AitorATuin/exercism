defmodule Atbash do
  @a 97
  @z 123
  @zero 48
  @nine 57

  defp encode_any(a) when a >= @zero and a <= @nine, do: a
  defp encode_any(a) when a >= @a and a <= @z, do: @z - 1 - a + @a
  defp encode_any(_), do: 0

  defp decode_any(a) when a >= @zero and a <= @nine, do: a
  defp decode_any(a) when a >= @a and a <= @z, do: @a + @z - 1 - a
  defp decode_any(_), do: 0

  @doc """
  Encode a given plaintext to the corresponding ciphertext

  ## Examples

  iex> Atbash.encode("completely insecure")
  "xlnko vgvob rmhvx fiv"
  """
  @spec encode(String.t()) :: String.t()
  def encode(plaintext) do
    plaintext 
    |> String.downcase()
    |> String.to_charlist()
    |> Enum.map(&encode_any/1)
    |> Enum.reject(&(&1 == 0))
    |> Enum.chunk_every(5)
    |> Enum.join(" ")
  end

  @spec decode(String.t()) :: String.t()
  def decode(cipher) do
    cipher
    |> String.to_charlist()
    |> Enum.map(&decode_any/1)
    |> Enum.reject(&(&1 == 0))
    |> to_string()
  end
end
