# coding: utf-8
require 'goodreads'
require 'awesome_print'
require 'active_support'
require 'yaml'
require 'pry'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

Goodreads.configure(
  api_key: ENV['GOODREADS_API_KEY'],
  api_secret: ENV['GOODREADS_API_SECRET']
)

client = Goodreads::Client.new

books = client.shelf(42730111, "read").books
books.each do |element|
  book = element['book']
  title = book['title'].gsub(/[\.:]\s.{7,}$/, '').parameterize
  date = DateTime.parse(element['read_at'] || element['date_added']).utc
  filename = "books/_posts/#{date.strftime("%Y-%m-%d")}-#{title}.org"
  tags = Array[element['shelves']['shelf']].flatten.select { |s| s['name'] != 'read' }.map { |s| s['name'] }
  author = book['authors']['author']['name']
  header = YAML.dump(
    'layout' => 'reading',
    'link' => book['link'],
    'title' => book['title'],
    'tags' => tags,
    'rating' => element['rating'] && element['rating'].to_i,
    'with_note' => false,
    'book_author' => author
  )

  if File.exist?(filename)
    file_contents = File.read(filename).gsub(/^---.*^---/m, '')
    File.open(filename, 'w+') do |f|
      f.puts(header)
      f.puts("---")
      f.puts(file_contents)
    end
  else
    File.open(filename, 'w+') do |f|
      f.puts(header)
      f.puts("---")
    end
  end
end
