class SynchronizeTrials
  Result = Struct.new(:already_stored, :queued, keyword_init: true)

  def initialize(range:, warehouse: WarehouseClient.new)
    @range = range
    @warehouse = warehouse
  end

  def call
    ids = []
    @warehouse.each_id(@range) { |id| ids << id }

    existing = Trial.where(uuid: ids).pluck(:uuid).to_set
    missing = ids.reject { |id| existing.include?(id) }

    missing.each { |id| FetchTrialJob.perform_async(id) }

    Result.new(already_stored: existing.size, queued: missing.size)
  end
end
