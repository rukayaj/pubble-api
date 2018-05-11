class ArtworksController < ApplicationController
  include HTTParty
  before_action :set_book, only: [:index, :create, :show, :update, :destroy]
  before_action :set_artwork, only: [:show, :update, :destroy]

  # GET /artworks
  def index
    @artworks = @book.artworks.all

    render json: @artworks
  end

  # GET /artworks/1
  def show
    render json: @artwork
  end

  # POST /artworks
  def create
    @artwork = @book.artworks.new(artwork_params)
    dst_url = 'http://www.dreamstime.com/api/'
    headers = {'Content-Type' => 'application/json'}

    # Auth token
    body = {'APIRequests': {'Authenticate': {'Verb': 'Authenticate', 'ApplicationId': 'WP-Plugin v2.0'}}}
    response = HTTParty.post(dst_url, body: body.to_json, headers: headers) 
    auth_token = response['APIResponses']['Authenticate']['AuthToken']

    # Get image object
    body = {'APIRequests': {'GetPaidImage': {'Verb': 'GetPaidImage', 'ImageId': @artwork.source_id, 'AuthToken': auth_token}}}
    response = HTTParty.post(dst_url, body: body.to_json, headers: headers) 
    image_object = JSON.parse(response.body)['APIResponses']['GetPaidImage']['Image']
    
    # Populate artwork
    @artwork.thumbnail_url = image_object['ThumbnailUrl']
    @artwork.copyright = image_object['Author']
    byebug
    if @artwork.save
      render json: @artwork, status: :created, location: book_url(@artwork)
    else
      render json: @artwork.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /artworks/1
  def update
    if @artwork.update(artwork_params)
      render json: @artwork
    else
      render json: @artwork.errors, status: :unprocessable_entity
    end
  end

  # DELETE /artworks/1
  def destroy
    @artwork.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artwork
      @artwork = Artwork.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Only allow a trusted parameter "white list" through.
    def artwork_params
      params.require(:artwork).permit(:book_id, :page, :topic, :source, :source_id, :notes)
      #params.require(:artwork).permit(:book_id, :page, :topic, :source, :source_id, :copyright, :thumbnail_url, :notes)
    end
end
