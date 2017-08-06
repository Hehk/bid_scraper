defmodule Scraper.Error do
  defstruct reason: nil, component: nil, context: nil
  @type t :: %__MODULE__{component: reference, reason: any, context: map}
end

defmodule Scraper do
  @moduledoc """
  Scraper server for managing scraping bidfta and updating the cache
  """
end
