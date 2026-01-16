# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require_relative "scraper"
require_relative "../models/proizvod"
require_relative "../models/cijena"

class LinksScraper < Scraper
  USER_AGENT = "Mozilla/5.0 (PriceTrackerBot)"

  def dohvati_proizvod(url)
    html = URI.open(url, "User-Agent" => USER_AGENT)
    doc = Nokogiri::HTML(html)

    naziv = doc.at_css("strong.current-item[itemprop='name']")&.text&.strip
    cijena_text = doc.at_css("span.old-price")&.text

    return nil if naziv.nil? || cijena_text.nil?

    iznos = cijena_text
              .gsub(".", "")
              .gsub(",", ".")
              .scan(/\d+\.?\d*/).first.to_f

    proizvod = Proizvod.new(
      naziv: naziv,
      trgovina: "Links",
      url: url
    )

    proizvod.dodaj_cijenu(Cijena.new(iznos))

    proizvod
  end

  def pretrazi_proizvod(pojam)

    puts pojam

    query = URI.encode_www_form_component(pojam)
    url = "https://www.links.hr"

    puts url

    response = HTTParty.get(
      url,
      headers: {
        "User-Agent" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36",
        "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "Accept-Language" => "hr-HR,hr;q=0.9,en-US;q=0.8,en;q=0.7",
        "Referer" => "https://www.links.hr/",
        "Connection" => "keep-alive"
      }
      )

    puts response.headers
    puts response.cookies

    puts response.code

    doc = Nokogiri::HTML(html)
    item = doc.css("div.col-6.col-md-4 div.cards--card").first
    link = item.at_css("a.card-link")

    puts link

    url = "https://www.links.hr" + link["href"]

    dohvati_proizvod(url)
  rescue
    []
  end
end
