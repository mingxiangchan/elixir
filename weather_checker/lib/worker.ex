defmodule WeatherChecker.Worker do
  # keeps process alive and able to receive location from sender, and send back the temperature to the sender
  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})
      _ ->
        IO.puts "don't know how to process this message"
    end
    loop
  end
          
  def temperature_of(location) do
    result = url_for(location) |> HTTPoison.get |>parse_response
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}C"
      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  def compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  def apikey do
    "6556f5e433ff1a8248e57a6f6ce26299"
  end
end

