require 'rails_helper'

describe "Artworks API" do
  
  before do
    @book = create(:book)
    @base_url = "/books/#{@book.id}/artworks"
  end

  it 'shows a list of artworks' do
    create_list(:artwork, 10, book_id: @book.id)
    get "#{@base_url}"
    artwork_list = JSON.parse(response.body)

    expect(response).to be_success
    expect(artwork_list.length).to eq(10)
  end
  
  it 'retrieves an artwork' do
    artwork = create(:artwork, book_id: @book.id)
    get "#{@base_url}/#{artwork.id}"
    retrieved_artwork = JSON.parse(response.body)
    expect(retrieved_artwork).to eq(JSON.parse(artwork.to_json))
  end 

  it 'creates an artwork and returns it' do
    artwork = build(:artwork, book_id: @book.id, thumbnail_url: '', copyright: '')
    dst_service = { thumbnail_url: 'http://myimage.com/cat.jpg', copyright: 'Furface' }
    allow_any_instance_of(DreamstimeService).to receive(:get_dst_image).with(artwork.source_id).and_return(dst_service )
    expect{ post @base_url, params: { artwork: artwork.attributes } }.to change(Artwork, :count).by(+1)
    expect(response).to have_http_status :created
    
    # The returned artwork should be the same as the one passed in apart from id and created/updated dates
    created_artwork = JSON.parse(response.body)
    artwork.id = created_artwork['id']
    artwork.created_at = Time.zone.parse(created_artwork['created_at'])
    artwork.updated_at = Time.zone.parse(created_artwork['updated_at'])
    expect(created_artwork).to eq(JSON.parse(artwork.to_json))
  end 

  it 'updates an artwork and returns it' do
    artwork = create(:artwork, copyright: "Jasper Meowface", book_id: @book.id)
    new_copyright = "Permy Meowface" 
    patch "#{@base_url}/#{artwork.id}", params: { artwork: { copyright: new_copyright } } 
    
    expect(response).to have_http_status :ok
    updated_artwork = JSON.parse(response.body)
    
    # Check that the updated details are returned and the modified date is updated
    expect(updated_artwork['copyright']).to eq(new_copyright)
    expect(Time.zone.parse(updated_artwork['updated_at'])).to be > artwork.updated_at
    
    # Check that it is updated in the database
    expect(Artwork.find(artwork.id).copyright).to eq(new_copyright)
  end

  it 'deletes an artwork' do
    artwork = create(:artwork, book_id: @book.id)
    second_artwork = create(:artwork, book_id: @book.id)
    expect{ delete "#{@base_url}/#{artwork.id}" }.to change(Artwork, :count).by(-1)
    expect(response).to have_http_status :no_content
    expect(Artwork.all).to eq([second_artwork])
  end

  it 'does not delete a book when an artwork is deleted' do
    artwork = create(:artwork, book_id: @book.id)
    expect{ delete "#{@base_url}/#{artwork.id}" }.to change(Artwork, :count).by(-1)
  end

end
