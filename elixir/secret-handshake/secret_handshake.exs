defmodule Op do
  defstruct val: nil, f: nil
end

defmodule SecretHandshake do
  use Bitwise

  def secretcode,
    do: [
      %Op{val: 1, f: fn xs -> ["wink" | xs] end},
      %Op{val: 2, f: fn xs -> ["double blink" | xs] end},
      %Op{val: 4, f: fn xs -> ["close your eyes" | xs] end},
      %Op{val: 8, f: &["jump" | &1]},
      %Op{val: 16, f: &Enum.reverse/1}
    ]

  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    ops = Enum.map(secretcode, fn op ->
      case op do
        # %Op{val: v, f: f} -> f
        %Op{val: v, f: f} when (code &&& v) == v -> f
        _ -> & &1
      end
    end)
    ops |> Enum.reduce([], fn f, xs -> f.(xs) end) |> Enum.reverse
  end
end
