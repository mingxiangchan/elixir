defmodule Rumbl.Repo do
  @moduledoc """
  In memory repository
  """

  def all(Rumbl.User) do
    [%Rumbl.User{id: "1", name: "Jose", username: "josevalim", password: "elixir"},
     %Rumbl.User{id: "2", name: "Bruce", username: "redrapids", password: "7langs"},
     %Rumbl.User{id: "3", name: "Chris", username: "chrismcord", password: "phx"}]
  end
  def all(__module__), do: []

  def get(module, id) do
    Enum.find all(module), fn map -> map.id == id end
  end

  def get_by(module, params) do
    Enum.find all(module), fn map->
      Enum.all?(params, fn {key, value} -> Map.get(map, key) == value end)
    end
  end



     
end
