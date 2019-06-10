defmodule LogflareLogger.Formatter do
  @moduledoc false
  alias LogflareLogger.LogEvent

  def format(level, message, ts, metadata) do
    try do
      LogEvent.new(ts, level, message, metadata)
      |> Map.from_struct()
    rescue
      e ->
        %{
          timestamp: NaiveDateTime.utc_now() |> NaiveDateTime.to_iso8601(),
          level: "error",
          message: "LogflareLogger formatter error: #{inspect(e, safe: true)}",
          context: %{
            formatter: %{
              error: inspect(e, safe: true),
              message: inspect(message, safe: true),
              metadata: inspect(metadata, safe: true)
            }
          }
        }
    end
  end
end
