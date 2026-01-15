# frozen_string_literal: true

class Scraper
  def initialize
    if self.class == Scraper
      raise "Scraper je apstraktna klasa i ne može se instancirati"
    end
  end
  def dohvatiProizvod(url)
    raise NotImplementedError,
          "#{self.class} mora implementirati dohvati_proizvod(url)"
  end

  # Pretražuje web-trgovinu po pojmu (npr. "RTX 4060")
  # Mora vratiti listu potencijalnih proizvoda
  def pretraziProizvod(pojam)
    raise NotImplementedError,
          "#{self.class} mora implementirati pretrazi_proizvod(pojam)"
  end

  # Naziv trgovine (Links, Instar, BigBang)
  def nazivTrgovine
    raise NotImplementedError,
          "#{self.class} mora implementirati naziv_trgovine"
  end
end