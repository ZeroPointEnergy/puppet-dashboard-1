# In Ruby 1.9 and up, FasterCSV is in stdlib and is called CSV.
if RUBY_VERSION < '1.9'
  require 'fastercsv'
  CSV = FasterCSV
else
  require 'csv'
end

class Array
  def to_csv
    header = first.class.to_csv_header if first.class.respond_to?(:to_csv_header)
    lines = map(&:to_csv)
    lines.unshift header if header
    lines.join
  end
end

class ActiveRecord::Base
  def self.to_csv_properties
    column_names
  end

  def self.to_csv_header
    CSV.generate_line to_csv_properties
  end

  def to_csv_array
    self.class.to_csv_properties.map {|prop| self.send(prop)}
  end

  def to_csv
    CSV.generate_line to_csv_array
  end
end
