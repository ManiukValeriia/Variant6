require 'net/http'
require 'uri'

# Список URL-адрес для запитів
urls = [
  "https://jsonplaceholder.typicode.com/posts/1",
  "https://jsonplaceholder.typicode.com/posts/2",
  "https://jsonplaceholder.typicode.com/posts/3",
  "https://jsonplaceholder.typicode.com/posts/4",
  "https://jsonplaceholder.typicode.com/posts/5"
]

# Функція для виконання HTTP-запиту
def fetch_url(url)
  uri = URI.parse(url)
  response = Net::HTTP.get_response(uri)
  puts "URL: #{url}, Статус: #{response.code}"
  response.body
end

# Створюємо потоки для запитів
threads = urls.map do |url|
  Thread.new do
    begin
      fetch_url(url)
    rescue StandardError => e
      puts "Помилка при обробці #{url}: #{e.message}"
    end
  end
end

# Очікуємо завершення всіх потоків
threads.each(&:join)

puts "Всі запити завершено."
