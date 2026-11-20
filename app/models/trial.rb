class Trial < ApplicationRecord
  validates :uuid, presence: true, uniqueness: true

  scope :ordered_for_export, -> {
    order(Arel.sql("start_time ASC NULLS LAST"), :uuid)
  }

  scope :filtered_by_start_time, ->(range) {
    relation = all
    if range.start_at && range.end_at
      relation.where(start_time: range.start_at..range.end_at)
    elsif range.start_at
      relation.where("start_time >= ?", range.start_at)
    elsif range.end_at
      relation.where("start_time <= ?", range.end_at)
    else
      relation
    end
  }
end
