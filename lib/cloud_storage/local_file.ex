defmodule CloudStorage.LocalFile do
  @moduledoc """
  Local File support to simulate CloudStorage. Mostly use for unit test purpose
  File will be saved under:

  *root_path/tmp/outreach-insights/<key>*

  where key is generated on per serializer
  """
  @behaviour CloudStorage

  def get(path, _options \\ []) do
    full_path = Path.join([root_path(), path])

    case File.read(full_path) do
      {:ok, content} ->
        {:ok,
         %{
           body: content,
           headers: [
             {"x-amz-id-2",
              "Z3HwoC+1I5EUD3lwctcmH4eMLWCLU26Ma7ImKfzCUk6UbzS+KGAjas1+AZ8KpL+fCF293ACrDzQ="},
             {"x-amz-request-id", "23C74C4AE5D40121"},
             {"Date", "Wed, 23 Jan 2019 23:47:47 GMT"},
             {"Last-Modified", "Wed, 23 Jan 2019 19:37:20 GMT"},
             {"ETag", "\"1ab9f3e6de3af1740b94ffbff9cb2545\""},
             {"x-amz-server-side-encryption", "AES256"},
             {"Accept-Ranges", "bytes"},
             {"Content-Type", "application/json"},
             {"Content-Length", "5762"},
             {"Server", "AmazonS3"}
           ],
           status_code: 200
         }}

      {:error, error} ->
        {:error, error}

      _ ->
        {:error, :unkown_error}
    end
  end

  def put(key, data, options \\ []) do
    full_path = Path.join([root_path(), key])

    # # create dir if needed
    File.mkdir_p!(Path.dirname(full_path))

    # #simulate saving special headers and metadata to S3
    headers_file = File.open!("#{full_path}.headers", [:utf8, :write])

    json_data = Jason.encode!(Keyword.to_list(options))
    IO.write(headers_file, json_data)

    # actual writting of the data at the key
    file = File.open!("#{full_path}", [:utf8, :write])
    IO.write(file, data)
    {:ok, %{status_code: 200, body: ""}}
  end

  def list(arg), do: arg

  def delete(key) do
    full_path = Path.join([root_path(), key])

    File.rm(full_path)
  end

  def root_path do
    "tmp/#{bucket_name()}"
  end

  def bucket_name do
    Application.get_env(:cloud_storage, :default_bucket_name) || raise "Missing required bucket"
  end
end
