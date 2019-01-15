defmodule CloudStorage do
  @moduledoc """
  An abstraction definition to implement different storages in our application

  Currently support the following implementations
    * LocalFile: Local file storage
    * S3File: AWs S3 storage
  """
  @callback get(path :: binary) :: {:ok, binary} | {:error, term}
  @callback put(path :: binary, data :: any, options :: Keyword) :: {:ok, binary} | {:error, term}
  @callback bucket_name() :: binary

  def cloud_store do
    Application.get_env(:cloud_storage, :store) || CloudStorage.LocalFile
  end
end
