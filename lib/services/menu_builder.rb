# frozen_string_literal: true

require_relative "./trgovina_service"
require_relative "./proizvod_store"

class MenuBuilder
  def run
    puts "=== Price Tracker ==="

    loop do
      puts "1-Dohvati proizvode, 2-Odaberi proizvod, 3-Kraj"
      izbor = gets.chomp.to_i

      case izbor
      when 1
        dohvatiProizvodeMenu()
      when 2
        odaberiProizvodMenu()
      when 3
        break
      else
        puts "Greška, ponovo unesite izbor."
      end
    end
  end

  def odaberiProizvodMenu()
    puts "Proizvodi:"
    proizvodi = ProizvodStore.new.load
    proizvodi.each_with_index do |proizvod, index|
      puts "#{index} - #{proizvod.naziv} (#{proizvod.trgovina})"
    end

    index = gets.chomp.to_i
    proizvod = proizvodi[index]

    loop do
      puts "1-Trenutna cijena, 2-minimalna cijena, 3-maksimalna cijena, 4-prosjecna cijena, 5-Prikaži podatke, 5-Kraj"
      izbor = gets.chomp.to_i
      case izbor
      when 1
        puts proizvod.trenutna_cijena
      when 2
        puts proizvod.minimalna_cijena
      when 3
        puts proizvod.maksimalna_cijena
      when 4
        puts proizvod.prosjecna_cijena
      when 5
        puts proizvod.to_s
      when 6
        break
      else
        puts "Greška, ponovo unesite izbor."
      end
    end
  end

  def dohvatiProizvodeMenu()
    puts "Unesi URL"
    url = gets.chomp
    trgovinaService = TrgovinaService.new
    scraper = trgovinaService.getScraper(url)

    if scraper.nil?
      puts 'Nepoznata trgovina, pokušajte ponovno!'
    end

    proizvod = scraper.dohvati_proizvod(url)
    izostaleTrgovine = trgovinaService.dohvatiIzostaleTrgovine(proizvod)

    proizvodi = [proizvod]

    izostaleTrgovine.each do |trg|
      proizvodi.push(trg.pretrazi_proizvod(proizvod.naziv))
    end

    puts proizvodi
    puts "---------------------------------------"
    puts "1-Spremi proizvode, 2-Pretraži drigi proizvod"
    izbor = gets.chomp.to_i
    if izbor == 1
      ProizvodStore.new.save(proizvodi)
    end
  end
end
