defmodule LogisticsOcr.Repo do
  use Ecto.Repo,
    otp_app: :logistics_ocr,
    adapter: Ecto.Adapters.Postgres
end
