defmodule BidSearch.AbsintheHelpers do
  @moduledoc """
  This module defines functions that are useful in making
  test for absinthe 
  """

  # simplifies making the skeleton for a query on absinthe
  def query_skeleton(query, query_name) do
    %{
      "operationName" => "#{query_name}",
      "query" => "query #{query_name} #{query}",
      "variables" => "{}"
    }
  end

  # Absinthe returns maps that use strings maps instead of atom maps
  def res_to_atoms(map) when is_map(map) do
    for {key, val} <- map, into: %{} do
      {String.to_atom(key), res_to_atoms(val)}
    end
  end
  def res_to_atoms(not_map), do: not_map
end
