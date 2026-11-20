class TrialImporter
  def initialize(item)
    @item = item
  end

  def call
    uuid = @item.fetch("id")
    return if Trial.exists?(uuid: uuid)

    cookie_trial = extract_cookie_trial
    attrs = {
      uuid: uuid,
      raw: cookie_trial || @item,
      score: dig_score(cookie_trial),
      cookie: dig_cookie(cookie_trial),
      audio_file_hash: dig_audio_file_hash(cookie_trial),
      start_time: dig_start_time(cookie_trial)
    }

    Trial.create!(attrs)
  rescue ActiveRecord::RecordNotUnique
    # Another worker stored this UUID first.
  end

  private

  def extract_cookie_trial
    json_item = @item["jsonItem"] || @item["json_item"]
    return nil unless json_item.is_a?(Hash)

    cookie_trial = json_item["cookie_trial"]
    cookie_trial.is_a?(Hash) ? cookie_trial : nil
  end

  def dig_score(cookie_trial)
    return nil unless cookie_trial

    trial = cookie_trial["trial"]
    return nil unless trial.is_a?(Hash)

    trial["score"]
  end

  def dig_cookie(cookie_trial)
    cookie_trial&.dig("cookie")
  end

  def dig_audio_file_hash(cookie_trial)
    cookie_trial&.dig("audio_file_hash")
  end

  def dig_start_time(cookie_trial)
    return nil unless cookie_trial

    trial = cookie_trial["trial"]
    return nil unless trial.is_a?(Hash)

    millis = trial["start_time"]
    return nil if millis.nil?

    Time.at(millis.to_f / 1000.0).utc
  end
end
