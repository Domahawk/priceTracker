require "bundler/setup"
require 'uri'

require_relative "lib/models/proizvod"
require_relative "lib/models/cijena"
require_relative "lib/scrapers/scraper"
require_relative "lib/scrapers/links_scraper"
require_relative "lib/scrapers/instar_scraper"

SCRAPERS = {
  "Links" => LinksScraper,
  "Instar" => InstarScraper,
}

def getScraper(url)
  uri = URI.parse(url)

  case uri.host
  when 'www.links.hr'
    LinksScraper.new
  when 'www.instar-informatika.hr'
    InstarScraper.new
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

loop do
  puts "Unesi URL"
  url = gets.chomp
  scraper = getScraper(url)

  if scraper.nil?
    puts 'Nepoznata trgovina, pokušajte ponovno!'
  end

  proizvod = scraper.dohvati_proizvod(url)
  missingStores = checkMissingStores(proizvod)

  proizvodi = [proizvod]

  missingStores.each do |store|
    proizvodi.push(store.pretrazi_proizvod(proizvod.naziv))
  end

  puts proizvodi
  #seriajizacija
end