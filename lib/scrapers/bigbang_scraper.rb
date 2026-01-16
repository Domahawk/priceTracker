# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require_relative "scraper"
require_relative "../models/proizvod"
require_relative "../models/cijena"
require_relative "../browser"

class BigbangScraper < Scraper
  USER_AGENT = "Mozilla/5.0 (PriceTrackerBot)"

  def dohvati_proizvod(url)
    driver = Browser.driver
    driver.navigate.to(url)

    wait = Selenium::WebDriver::Wait.new(timeout: 15)

    wait.until { driver.find_element(class: "old-price") }

    naziv = driver.find_element(class: "cd-title").text
    cijena_text = driver.find_element(class: "old-price").text

    puts naziv
    puts cijena_text

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
end
