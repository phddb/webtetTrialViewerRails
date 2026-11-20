class SynchronizationsController < ApplicationController
  def create
    range = DateRange.from_params(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )
    result = SynchronizeTrials.new(range: range).call

    render json: {
      already_stored: result.already_stored,
      queued: result.queued
    }
  rescue DateRange::Invalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue WarehouseClient::Error => e
    render json: { error: e.message }, status: :bad_gateway
  end
end
