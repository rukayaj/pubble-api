require 'rails_helper'

describe "Books API" do

  it 'shows a list of books' do
    create_list(:book, 10)
    get '/books'
    book_list = JSON.parse(response.body)

    expect(response).to be_success

    expect(book_list.length).to eq(10)
  end
  
  it 'retrieves a book' do
    book = create(:book)
    get "/books/#{book.id}"
    retrieved_book = JSON.parse(response.body)
    expect(retrieved_book).to eq(JSON.parse(book.to_json))
  end 

  it 'creates a book and returns it' do
    book = build(:book)
    expect{ post "/books", params: { book: book.attributes } }.to change(Book, :count).by(+1)
    expect(response).to have_http_status :created
    
    # The returned book should be the same as the one passed in apart from id and created/updated dates
    created_book = JSON.parse(response.body)
    book.id = created_book['id']
    book.created_at = Time.zone.parse(created_book['created_at'])
    book.updated_at = Time.zone.parse(created_book['updated_at'])
    expect(created_book).to eq(JSON.parse(book.to_json))
  end 

  it 'updates a book and returns it' do
    book = create(:book, country: "Albania")
    new_country = "South Africa" 
    patch "/books/#{book.id}", params: { book: { country: new_country } } 
    
    expect(response).to have_http_status :ok
    updated_book = JSON.parse(response.body)
    
    # Check that the updated details are returned and the modified date is updated
    expect(updated_book['country']).to eq(new_country)
    expect(Time.zone.parse(updated_book['updated_at'])).to be > book.updated_at
    
    # Check that it is updated in the database
    expect(Book.find(book.id).country).to eq(new_country)
  end

  it 'deletes a book' do
    book = create(:book)
    second_book = create(:book)
    expect{ delete "/books/#{book.id}" }.to change(Book, :count).by(-1)
    expect(response).to have_http_status :no_content
    expect(Book.all).to eq([second_book])
  end

  it 'deletes the artwork when a book is deleted' do
    book = create(:book)
    artwork = create(:artwork, book_id: book.id)
    expect{ delete "/books/#{book.id}" }.to change(Artwork, :count).by(-1)
  end

end
