require "bundler/setup"
require 'uri'

require_relative "lib/models/proizvod"
require_relative "lib/models/cijena"
require_relative "lib/scrapers/scraper"
require_relative "lib/scrapers/links_scraper"
require_relative "lib/scrapers/instar_scraper"
require_relative "lib/scrapers/bigbang_scraper"

def getScraper(url)
  uri = URI.parse(url)

  case uri.host
  when 'www.links.hr'
    LinksScraper.new
  when 'www.instar-informatika.hr'
    InstarScraper.new
  when 'www.bigbang.hr'
    BigbangScraper.new
  else
    nil
  end
end

puts "=== Price Tracker ==="

loop do
  puts "Unesi URL"
  url = gets.chomp
  scraper = getScraper(url)

  if scraper.nil?
    puts 'Nepoznata trgovina, pokušajte ponovno!'
  end

  scraper.dohvati_proizvod(url)
end

#https://www.links.hr/hr/izlozbeni-laptop-gigabyte-aero-15-kc-8ee5130sp-core-i7-10870h-16gb-512gb-ssd-geforce-rtx-3060p-6gb-105w-156-4k-oled-windows-10-pro-crni-0101011165