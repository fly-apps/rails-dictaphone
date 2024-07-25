class WhisperTranscribeJob < ApplicationJob
  queue_as :default

  def perform(clip)
    input = { audio: clip.contents.url }
    uri = URI.parse(ENV['WHISPER_URL'])

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
      request.body = { input: input }.to_json
      http.request(request)
    end

    results = JSON.parse(response.body)

    clip.update!(text: results['output']['transcription'])
  end
end
