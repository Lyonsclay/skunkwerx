json.array!(@malone_tunes) do |malone_tune|
  json.extract! malone_tune, :id
  json.url malone_tune_url(malone_tune, format: :json)
end
