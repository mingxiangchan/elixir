require IEx

defmodule Metex.Worker do
  use GenServer #1

  # Client API
  
  def start_link(opts \\ []) do
    # __MODULE__ => module name : Metex
    # second arg => arguements to be passed to init
    # calls self.init
    GenServer.start_link(__MODULE__, :ok, opts)
  end
 
  def get_temperature(pid, location) do
    GenServer.call(pid, {:location, location})
  end

  def get_stats(pid) do
    GenServer.call(pid, :get_stats)
  end
 
  def reset_stats(pid) do
    GenServer.cast(pid, :reset_stats)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end
  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:location, location}, _from, stats) do
    case temperature_of(location) do
      {:ok, temp} ->
        new_stats = update_stats(stats, location)
        {:reply, "#{temp}C", new_stats}
      _ ->
        {:reply,:error, stats}
    end
  end

  def handle_call(:get_stats, _from, stats) do
    {:reply, stats, stats}
  end

  def handle_cast(:reset_stats, _stats) do
    {:noreply, %{}}
  end

  def handle_cast(:stop, stats) do
    {:stop, :normal, stats)
  end

  def terminate(reason, stats) do
    IO.puts "server terminated because of #{inspect reason}"
    inspect stats
    :ok
  end

  ## Helper Functions

  def temperature_of(location) do
    url_for(location) |> HTTPoison.get |> parse_response
  end

  def url_for(location) do
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&APPID=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |>compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  def compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] -273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ ->
      :error
    end
  end
     
  def apikey do
    "6556f5e433ff1a8248e57a6f6ce26299"
  end

  defp update_stats(old_stats, location) do
    case Map.has_key?(old_stats, location) do
      true ->
        Map.update!(old_stats, location, &(&1 +1))
      false ->
        Map.put_new(old_stats, location, 1)
    end
  end

end
