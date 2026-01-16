require "bundler/setup"
require 'uri'

require_relative "lib/models/proizvod"
require_relative "lib/models/cijena"
require_relative "lib/scrapers/scraper"
require_relative "lib/scrapers/links_scraper"
require_relative "lib/scrapers/instar_scraper"
require_relative "lib/scrapers/bigbang_scraper"

SCRAPERS = {
  "Links" => LinksScraper,
  "Instar" => InstarScraper,
  "BigBang" => BigbangScraper
}

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

def checkMissingStores(proizvod)
  if proizvod.nil?
    puts "Nepoznata trgovina ili proizvod."
    return []
  end

  available = SCRAPERS.dup
  available.delete(proizvod.trgovina)

  available.values.map { |scraper_class| scraper_class.new }
end

puts "=== Price Tracker ==="

linksScraper = BigbangScraper.new
rez = linksScraper.dohvati_proizvod("https://www.bigbang.hr/laptop-apple-macbook-air-midnight-mc7x4cr-a-13-6-p-21587284/")

puts rez


# loop do
#   puts "Unesi URL"
#   url = gets.chomp
#   scraper = getScraper(url)
#
#   if scraper.nil?
#     puts 'Nepoznata trgovina, pokušajte ponovno!'
#   end
#
#   proizvod = scraper.dohvati_proizvod(url)
#
#   puts proizvod.naziv
#   proizvod.cijene.each { |cijena| puts cijena.iznos }
#
#
#   missingStores = checkMissingStores(proizvod)
#
#   proizvodi = []
#
#   missingStores.each do |store|
#     proizvodi += store.pretrazi_proizvod(proizvod.naziv)
#   end
# end

#https://www.links.hr/hr/izlozbeni-laptop-gigabyte-aero-15-kc-8ee5130sp-core-i7-10870h-16gb-512gb-ssd-geforce-rtx-3060p-6gb-105w-156-4k-oled-windows-10-pro-crni-0101011165