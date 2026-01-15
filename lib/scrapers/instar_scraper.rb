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

    naziv = doc.at_css("h1")&.text&.strip
    cijena_text = doc.at_css("span.price")&.text

    return nil if naziv.nil? || cijena_text.nil?

    iznos = cijena_text
              .gsub(".", "")
              .gsub(",", ".")
              .scan(/\d+\.?\d*/).first.to_f

    model = extract_model(naziv)

    proizvod = Proizvod.new(
      naziv: naziv,
      model: model,
      trgovina: "Links",
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
    url = "https://www.links.hr/search?query=#{query}"

    html = URI.open(url, "User-Agent" => USER_AGENT)
    doc = Nokogiri::HTML(html)

    proizvodi = []

    doc.css(".product-item").each do |item|
      naziv = item.at_css(".product-name")&.text&.strip
      cijena = item.at_css(".price")&.text

      next if naziv.nil? || cijena.nil?

      iznos = cijena.gsub(".", "").gsub(",", ".").scan(/\d+\.?\d*/).first.to_f

      proizvodi << {
        naziv: naziv,
        iznos: iznos
      }
    end

    proizvodi
  rescue
    []
  end
  private

  def extract_model(naziv)
    # Uzmi prve 3–4 riječi (npr "RTX 4060 Dual")
    naziv.split(" ")[0..3].join(" ")
  end
end
