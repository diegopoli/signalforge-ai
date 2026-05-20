module Ai
  class Embeddings
    def initialize
      @client = ClientFactory.build
    end

    def call(text:)
      response = @client.embeddings(
        parameters: {
          model: ProviderConfig.embedding_model,
          input: text
        }
      )

      response.dig("data", 0, "embedding")
    end
  end
end
