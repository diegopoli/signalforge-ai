Rails.application.config.x.ai = ActiveSupport::OrderedOptions.new
Rails.application.config.x.ai.provider = ENV.fetch("AI_PROVIDER", "openai")
Rails.application.config.x.ai.rag_enabled = ENV.fetch("FEATURE_RAG_ENABLED", "true") == "true"
