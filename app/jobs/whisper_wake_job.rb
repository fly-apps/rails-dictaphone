class WhisperWakeJob < ApplicationJob
  queue_as :default

  def perform(*args)    
    Net::HTTP.get_response(URI.parse(ENV['WHISPER_URL']))
  end
end
