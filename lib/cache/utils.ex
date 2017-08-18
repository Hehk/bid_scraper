defmodule Cache.Utils do
  @moduledoc """
  Utils functions used within other caches
  """

  def validate_required(map, []), do: true
  def validate_required(map, [field | rhs]) do
    case Map.has_key?(map, field) do
      true  -> validate_required(map, rhs)
      false -> false
    end
  end

  def remove_fields(map, []), do: map
  def remove_fields(map, [field | rhs]) do
    {_val, clean_map} = Map.pop(map, field)
    remove_fields(clean_map, rhs)
  end
end
