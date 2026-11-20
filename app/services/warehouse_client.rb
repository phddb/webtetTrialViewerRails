require "net/http"
require "json"
require "uri"

class WarehouseClient
  class Error < StandardError; end

  PER_PAGE = 100

  def initialize(base_url: ENV.fetch("WAREHOUSE_URL", "https://jsontocsvpipeline.onrender.com"))
    @base_url = base_url.delete_suffix("/")
  end

  def each_id(range)
    page = 1
    total = nil

    loop do
      body, headers = get_json("/item", range.warehouse_query.merge(page: page, per_page: PER_PAGE))
      total_header = Array(headers["x-total-count"]).first
      total ||= Integer(total_header || body.length)
      ids = Array(body)

      ids.each { |id| yield id }

      break if ids.empty? || (page * PER_PAGE) >= total

      page += 1
    end
  end

  def fetch_item(id)
    body, = get_json("/item/#{id}")
    body
  end

  private

  def get_json(path, query = {})
    uri = URI("#{@base_url}#{path}")
    uri.query = URI.encode_www_form(query) if query.any?

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 30, read_timeout: 60) do |http|
      http.request(Net::HTTP::Get.new(uri))
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise Error, "Warehouse #{path} failed with #{response.code}: #{response.body.to_s.truncate(200)}"
    end

    [JSON.parse(response.body), response.to_hash.transform_keys(&:downcase)]
  rescue JSON::ParserError => e
    raise Error, "Warehouse returned invalid JSON: #{e.message}"
  rescue Timeout::Error, Errno::ECONNREFUSED, SocketError => e
    raise Error, "Warehouse request failed: #{e.message}"
  end
end
