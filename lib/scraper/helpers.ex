defmodule Scraper.Helpers do
  # uses HTTPoison get with tlsv1.2 to prevent errors when being called in 
  # a gen server
  def http_get(url), do: HTTPoison.get(url, [], [ssl: [{:versions, [:'tlsv1.2']}]])
end
