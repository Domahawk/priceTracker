# frozen_string_literal: true

require_relative "scraper"
require_relative "../models/proizvod"
require_relative "../models/cijena"

class LinksScraper < Scraper
  USER_AGENT = "Mozilla/5.0 (PriceTrackerBot)"

  def dohvati_proizvod(url)
    driver = Browser.driver
    driver.navigate.to(url)

    wait = Selenium::WebDriver::Wait.new(timeout: 15)

    cookie_button = wait.until {
      driver.find_element(class: "cky-btn-accept")
    }
    cookie_button.click

    wait.until { driver.find_element(css: "span[class^='price-value-']") }

    naziv = driver.find_element(css: "div.product-name h1").text
    cijena_text = driver.find_element(css: "span[class^='price-value-']").text

    driver.quit

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
    url = "https://www.links.hr/search/?q=#{query}"

    driver = Browser.driver
    driver.navigate.to(url)

    wait = Selenium::WebDriver::Wait.new(timeout: 15)

    cookie_button = wait.until {
      driver.find_element(class: "cky-btn-accept")
    }

    cookie_button.click

    wait.until { driver.find_element(class: "card-link") }

    link = driver.find_element(class: "card-link").attribute("href")

    driver.quit

    dohvati_proizvod(link)
  end
end
