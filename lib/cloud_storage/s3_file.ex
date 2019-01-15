defmodule CloudStorage.S3File do
  @moduledoc """
    This is the storage on  AWS S3 support
  """
  alias ExAws.S3

  @behaviour CloudStorage

  def get(key, _options \\ []) do
    bucket_name() |> S3.get_object(key) |> ExAws.request()
  end

  def put(key, data, _options \\ []) do
    bucket_name() |> S3.put_object(key, data) |> ExAws.request()
  end

  def list(prefix) do
    bucket_name() |> S3.list_objects(prefix: prefix) |> ExAws.stream!()
  end

  def delete(object) do
    bucket_name() |> S3.delete_object(object) |> ExAws.request()
  end

  def bucket_name do
    Application.get_env(:cloud_storage, :default_bucket_name) || raise "Missing required bucket"
  end
end
