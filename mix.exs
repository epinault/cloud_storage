defmodule CloudStorage.MixProject do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :cloud_storage,
      version: @version,
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "Cloud Storage",
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:sweet_xml, "~> 0.6.5"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 0.8.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp docs do
    [
      assets: "doc_sources/images",
      main: "README",
      source_ref: @version,
      logo: "doc_sources/images/outreach-logo.png",
      source_url: "https://github.com/getoutreach/cloud_storage",
      extras:
        [
          "README.md"
        ] ++ Path.wildcard("doc_sources/*.md")
    ]
  end
end
