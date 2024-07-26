class ClipsController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_clip, only: %i[ show edit update destroy ]

  # GET /clips or /clips.json
  def index
    @clips = Clip.all
    WhisperWakeJob.perform_later if ENV['WHISPER_URL']
  end

  # GET /clips/1 or /clips/1.json
  def show
  end

  # GET /clips/new
  def new
    @clip = Clip.new
  end

  # GET /clips/1/edit
  def edit
  end

  # POST /clips or /clips.json
  def create
    name = URI.decode_uri_component(request.headers['Content-Disposition'][/filename="(.+)"/, 1])
    clip = Clip.new(name: name)
    clip.contents.attach(
      io: request.body,
      filename: name,
      content_type: request.headers['Content-Type']
    )
    clip.save!

    render json: { id: clip.id, name: clip.name }

    WhisperTranscribeJob.perform_later(clip) if ENV['WHISPER_URL']
  end

  # PATCH/PUT /clips/1 or /clips/1.json
  def update
    respond_to do |format|
      if @clip.update(clip_params)
        format.html { redirect_to clips_url, notice: "Clip was successfully updated." }
        format.json { render :show, status: :ok, location: @clip }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @clip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clips/1 or /clips/1.json
  def destroy
    @clip.destroy!

    respond_to do |format|
      format.html { redirect_to clips_url, notice: "Clip was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clip
      @clip = Clip.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def clip_params
      params.require(:clip).permit(:name, :text)
    end
end
