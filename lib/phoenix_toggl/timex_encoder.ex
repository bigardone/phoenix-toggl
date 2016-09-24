defimpl Poison.Encoder, for: DateTime do
  def encode(d, _options) do
    fmt = Timex.format!(d, "{ISO:Extended}")
    "\"#{fmt}\""
  end
end
