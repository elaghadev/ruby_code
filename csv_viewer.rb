require 'csv'
require 'tty-prompt'
require 'console_table'
require 'pry'

class CsvFetcher
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def fetch_csv_files
    Dir.glob(File.join(@path, '*.csv'))
  end
end

class CsvReader
  def initialize(file_path)
    @file_path = file_path
  end

  def read_csv
    CSV.read(@file_path, headers: true)
  end
end

class CsvDisplayer
  def display(data)
    table = ConsoleTable
    table = data.headers

    data.each do |row|
      table << row.fields
    end

    puts table
  end
end

class CsvApp
def initialize(path)
  @fetcher = CsvFetcher.new(path)
  @prompt = TTY::Prompt.new
end

def run
  loop do
    csv_files = @fetcher.fetch_csv_files

    if csv_files.empty?
    puts "No CSV files found in the specified directory."
    end

    selected_file = @prompt.select("Choose one of these CSV file?", csv_files + ['Quit'])
    break if selected_file == 'Quit'
    
    reader = CsvReader.new(selected_file)
    data = reader.read_csv

    displayer = CsvDisplayer.new
    displayer.display(data)
  end
end
end

# Main Execution
if __FILE__ == $0
  path = ARGV[0] || '.'
  app = CsvApp.new(path)
  app.run
end