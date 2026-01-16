# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require_relative "scraper"
require_relative "../models/proizvod"
require_relative "../models/cijena"

class InstarScraper < Scraper
  USER_AGENT = "Mozilla/5.0 (PriceTrackerBot)"

  def dohvati_proizvod(url)
    html = URI.open(url, "User-Agent" => USER_AGENT)
    doc = Nokogiri::HTML(html)

    naziv = doc.at_css("h1.c-title")&.text&.strip
    cijena_text = doc.at_css("span.mainprice")&.text

    return nil if naziv.nil? || cijena_text.nil?

    iznos = cijena_text
              .gsub(".", "")
              .gsub(",", ".")
              .scan(/\d+\.?\d*/).first.to_f

    proizvod = Proizvod.new(
      naziv: naziv,
      trgovina: "Instar",
      url: url
    )

    proizvod.dodaj_cijenu(Cijena.new(iznos))

    proizvod
  rescue => e
    puts "Greška pri dohvaćanju s Linksa: #{e.message}"
    nil
  end

  def pretrazi_proizvod(pojam)
    query = URI.encode_www_form_component(pojam)
    url = "https://www.instar-informatika.hr/Search/?fs=1&term?#{query}"

    puts url

    html = URI.open(url, "User-Agent" => USER_AGENT)
    doc = Nokogiri::HTML(html)

    grid = doc.at_css("#grid div.productEntity")

    puts grid

    # items = grid.css("div.productEntity")
    # firstItem = items.first
    # puts firstItem
    #
    # item = firstItem.at_css("a.productEntityClick")
    #
    # link = item.at_css("a.card-link")
    #
    # puts link
    #
    # url = "https://www.instar-informatika.hr" + link["href"]
    #
    # dohvati_proizvod(url)
  end
end
