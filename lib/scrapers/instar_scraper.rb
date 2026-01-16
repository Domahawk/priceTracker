# frozen_string_literal: true

require "nokogiri"
require "open-uri"
require_relative "scraper"
require_relative "../models/proizvod"
require_relative "../models/cijena"
require_relative "../browser"

class InstarScraper < Scraper
  USER_AGENT = "Mozilla/5.0 (PriceTrackerBot)"

  def dohvati_proizvod(url)
    driver = Browser.driver
    driver.navigate.to(url)

    wait = Selenium::WebDriver::Wait.new(timeout: 15)
    wait.until { driver.find_element(class: "c-title") }

    naziv = driver.find_element(class: "c-title").text
    cijena_text = driver.find_element(class: "mainprice").text

    driver.quit

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
  end

  def pretrazi_proizvod(pojam)
    query = URI.encode_www_form_component(pojam)
    url = "https://www.instar-informatika.hr/Search/?term=#{query}"

    puts url

    driver = Browser.driver
    driver.navigate.to(url)

      wait = Selenium::WebDriver::Wait.new(timeout: 15)

    wait.until { driver.find_element(css: "div.product-content h2.title a.productEntityClick") }

    link = driver.find_element(css: "div.product-content h2.title a.productEntityClick").attribute("href")

    puts link

    driver.quit

    dohvati_proizvod(link)
  end
end

