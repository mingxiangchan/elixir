defmodule WeatherChecker do
  def temperatures_of(cities) do
    coordinator_pid = spawn(WeatherChecker.Coordinator, :loop, [[], Enum.count(cities)])

    cities |> Enum.each(fn city ->
      worker_pid = spawn(WeatherChecker.Worker, :loop, [])
     send worker_pid, {coordinator_pid, city}
    end)
  end
end
