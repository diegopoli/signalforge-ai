module Ai
  module ProviderConfig
    module_function

    def provider
      ENV.fetch("AI_PROVIDER", "openai")
    end

    def rag_enabled?
      ENV.fetch("FEATURE_RAG_ENABLED", "true") == "true"
    end

    def api_key
      if provider == "deepseek"
        ENV["DEEPSEEK_API_KEY"]
      else
        ENV["OPENAI_API_KEY"]
      end
    end

    def base_uri
      return ENV["DEEPSEEK_BASE_URI"].presence || "https://api.deepseek.com" if provider == "deepseek"

      nil
    end

    def chat_model
      if provider == "deepseek"
        ENV.fetch("DEEPSEEK_CHAT_MODEL", "deepseek-chat")
      else
        ENV.fetch("OPENAI_CHAT_MODEL", "gpt-4o-mini")
      end
    end

    def embedding_model
      if provider == "deepseek"
        ENV.fetch("DEEPSEEK_EMBEDDING_MODEL", "text-embedding-3-small")
      else
        ENV.fetch("OPENAI_EMBEDDING_MODEL", "text-embedding-3-small")
      end
    end
  end
end
