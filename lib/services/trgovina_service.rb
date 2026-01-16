# frozen_string_literal: true

require "uri"
require_relative "../scrapers/links_scraper"
require_relative "../scrapers/instar_scraper"

class TrgovinaService
  SCRAPERS = {
    "Links" => LinksScraper,
    "Instar" => InstarScraper,
  }

  def dohvatiIzostaleTrgovine(proizvod)
    if proizvod.nil?
      puts "Nepoznata trgovina ili proizvod."
      return []
    end

    available = SCRAPERS.dup
    available.delete(proizvod.trgovina)

    available.values.map { |scraper_class| scraper_class.new }
  end

  def getScraper(url)
    uri = URI.parse(url)

    case uri.host
    when 'www.links.hr'
      SCRAPERS["Links"].new
    when 'www.instar-informatika.hr'
      SCRAPERS["Instar"].new
    else
      nil
    end
  end
end
