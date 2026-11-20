require "csv"

class ExportsController < ApplicationController
  COLUMNS = %w[uuid start_time score cookie audio_file_hash].freeze

  def show
    range = DateRange.from_params(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )

    trials = Trial.filtered_by_start_time(range).ordered_for_export

    csv = CSV.generate do |rows|
      rows << COLUMNS
      trials.each do |trial|
        rows << [
          trial.uuid,
          format_time(trial.start_time),
          trial.score,
          trial.cookie,
          trial.audio_file_hash
        ]
      end
    end

    send_data csv,
              filename: "trials.csv",
              type: "text/csv; charset=utf-8",
              disposition: "attachment"
  rescue DateRange::Invalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def format_time(value)
    return nil if value.nil?

    value.utc.iso8601(3)
  end
end
