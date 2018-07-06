defmodule ProteinTranslation do

  @codons %{
    "UGU" =>  "Cysteine",
    "UGC" =>  "Cysteine",
    "UUA" =>  "Leucine",
    "UUG" =>  "Leucine",
    "AUG" =>  "Methionine",
    "UUU" =>  "Phenylalanine",
    "UUC" =>  "Phenylalanine",
    "UCU" =>  "Serine",
    "UCC" =>  "Serine",
    "UCA" =>  "Serine",
    "UCG" =>  "Serine",
    "UGG" =>  "Tryptophan",
    "UAU" =>  "Tyrosine",
    "UAC" =>  "Tyrosine",
    "UAA" =>  "STOP",
    "UAG" =>  "STOP",
    "UGA" =>  "STOP",
  }

  defp of_rna_r(_, [{:ok, "STOP"}|xs]), do: {:ok, xs |> Enum.reverse()}
  defp of_rna_r(<<c::binary-3>> <> rna, []), do: of_rna_r(rna, [ProteinTranslation.of_codon(c)])
  defp of_rna_r(<<c::binary-3>> <> rna, [{:ok, x}|xs]), do: of_rna_r(rna, [ProteinTranslation.of_codon(c)|[x|xs]])
  defp of_rna_r("", [{:ok, x}|xs]), do: {:ok, [x|xs] |> Enum.reverse()}
  defp of_rna_r(_, [{:error, _}|_]), do: {:error, "invalid RNA"}

  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna), do: of_rna_r(rna, [])

  @doc """
  Given a codon, return the corresponding protein
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do 
    case @codons do
      %{^codon => rna} -> {:ok, rna}
      _ -> {:error, "invalid codon"}
    end
  end
end
