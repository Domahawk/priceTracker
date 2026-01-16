# frozen_string_literal: true

require_relative "./trgovina_service"
require_relative "./proizvod_store"
require_relative "../cli"

class MenuBuilder
  def run
    CLI.title("Price Tracker")

    loop do
      CLI.menu(["Dohvati proizvode", "Odaberi proizvod", "Kraj"])
      izbor = gets.chomp.to_i

      case izbor
      when 0
        dohvatiProizvodeMenu()
      when 1
        odaberiProizvodMenu()
      when 2
        break
      else
        CLI.error("Nepoznata opcija, ponovo unseite izbor.")
      end
    end
  end

  def odaberiProizvodMenu()
    CLI.title("Odaberi proizvod")
    proizvodi = ProizvodStore.new.load
    redovi = proizvodi.each_with_index.map do |proizvod, index|
      [index, proizvod.naziv, proizvod.trgovina]
    end

    CLI.table(["Index", "Naziv", "Trgovina"], redovi)

    index = gets.chomp.to_i
    proizvod = proizvodi[index]

    loop do
      CLI.menu(["Trenutna cijena", "Minimalna cijena", "Maksimalna cijena", "Prosjecna cijena", "Prikaži podatke", "Kraj"])

      izbor = gets.chomp.to_i
      case izbor
      when 0
        puts proizvod.trenutna_cijena
      when 1
        puts proizvod.minimalna_cijena
      when 2
        puts proizvod.maksimalna_cijena
      when 3
        puts proizvod.prosjecna_cijena
      when 4
        puts proizvod.to_s
      when 5
        break
      else
        CLI.error("Nepoznata opcija, ponovo unesite izbor.")
      end
    end
  end

  def dohvatiProizvodeMenu()
    puts "Unesi URL"
    url = gets.chomp
    trgovinaService = TrgovinaService.new
    scraper = trgovinaService.getScraper(url)

    if scraper.nil?
      CLI.error("Nepoznata trgovina, pokušajte ponovno!")
    end

    proizvod = scraper.dohvati_proizvod(url)
    izostaleTrgovine = trgovinaService.dohvatiIzostaleTrgovine(proizvod)

    proizvodi = [proizvod]

    izostaleTrgovine.each do |trg|
      proizvodi.push(trg.pretrazi_proizvod(proizvod.naziv))
    end

    puts proizvodi
    CLI.menu(["Spremi proizvode", "Nastavi"])
    izbor = gets.chomp.to_i
    if izbor == 0
      ProizvodStore.new.save(proizvodi)
    end
  end
end
