namespace :books do
  namespace :import do
    task :isbn => :environment do
      isbn = STDIN.readline
      puts isbn.inspect
      book = Book.new IsbnLookup.lookup(isbn)
      book.save!
      puts "saved: #{book.inspect}"
    end
  end
end
