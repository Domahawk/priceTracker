# frozen_string_literal: true

module CLI
  WIDTH = 70

  def self.line(char = "-")
    puts char * WIDTH
  end

  def self.center(text)
    puts text.center(WIDTH)
  end

  def self.title(text)
    line("=")
    center(text.upcase)
    line("=")
  end

  def self.menu(options)
    options.each_with_index do |opt, i|
      puts "#{i}-#{opt}"
    end
    puts "\nUnesite broj opcije: "
  end

  def self.table(headers, rows)
    col_widths = headers.map.with_index do |h, i|
      ([h.length] + rows.map { |r| r[i].to_s.length }).max
    end

    format = col_widths.map { |w| "%-#{w}s" }.join(" | ")

    puts format % headers
    puts col_widths.map { |w| "-" * w }.join("-+-")

    rows.each do |row|
      puts format % row
    end
  end

  def self.pause
    puts "\nPritisni ENTER za nastavak..."
    gets
  end

  def self.error(msg)
    puts "\e[31mGreška: #{msg}\e[0m"
  end
end
