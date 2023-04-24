algolia_app_id = ENV.fetch('ALGOLIA_APP_ID', nil)
algolia_api_key = ENV.fetch('ALGOLIA_API_KEY', nil)

if algolia_app_id.present? && algolia_api_key.present?
  AlgoliaSearch.configuration = {
    application_id: algolia_app_id,
    api_key: algolia_api_key
  }
end
