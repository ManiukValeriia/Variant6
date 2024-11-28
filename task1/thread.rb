require 'thread'

# Імена файлів
input_file = "numbers.txt"
output_file = "squares.txt"

# Читаємо числа з файлу
numbers = File.readlines(input_file).map(&:to_i)

# Черга для потоків
queue = Queue.new
numbers.each { |number| queue << number }

# Блокування для синхронізації запису у файл
mutex = Mutex.new

# Функція для обробки числа
def calculate_square(queue, output_file, mutex)
  until queue.empty?
    begin
      number = queue.pop(true) # Забираємо число з черги
      square = number**2

      # Синхронізуємо запис у файл
      mutex.synchronize do
        File.open(output_file, "a") { |file| file.puts "#{number}: #{square}" }
      end
    rescue ThreadError
      # Якщо черга порожня
      break
    end
  end
end

# Очищуємо файл для запису
File.open(output_file, "w") {}

# Створюємо потоки
threads = []
4.times do
  threads << Thread.new { calculate_square(queue, output_file, mutex) }
end

# Очікуємо завершення всіх потоків
threads.each(&:join)

puts "Обробка завершена. Результати записані у #{output_file}."
