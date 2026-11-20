class FetchTrialJob
  include Sidekiq::Job

  sidekiq_options retry: 5

  def perform(uuid)
    item = WarehouseClient.new.fetch_item(uuid)
    TrialImporter.new(item).call
  end
end
