defmodule Op do
  use Bitwise
  defstruct val: nil, f: nil

  defp _run(xs, %Op{val: v, f: f}, code) when (code &&& v) === v, do: f.(xs)
  defp _run(xs, %Op{val: _, f: _}, _), do: xs
  def run(code), do: fn op, xs -> _run(xs, op, code) end
end

defmodule SecretHandshake do
  def secretcode,
    do: [
      %Op{val: 1, f: &["wink" | &1]},
      %Op{val: 2, f: &["double blink" | &1]},
      %Op{val: 4, f: &["close your eyes" | &1]},
      %Op{val: 8, f: &["jump" | &1]},
      %Op{val: 16, f: &Enum.reverse/1}
    ]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    secretcode() |> Enum.reduce([], Op.run(code)) |> Enum.reverse()
  end
end
