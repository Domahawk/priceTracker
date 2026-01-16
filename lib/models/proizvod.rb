# frozen_string_literal: true

require_relative "cijena"

class Proizvod
  attr_reader :naziv, :trgovina, :url, :cijene

  def initialize(naziv:, trgovina:, url:)
    @naziv = naziv
    @trgovina = trgovina
    @url = url
    @cijene = []
  end

  def dodaj_cijenu(cijena)
    @cijene << cijena
  end

  def trenutna_cijena
    return nil if @cijene.empty?
    @cijene.last.iznos
  end

  def minimalna_cijena
    return nil if @cijene.empty?
    @cijene.map(&:iznos).min
  end

  def maksimalna_cijena
    return nil if @cijene.empty?
    @cijene.map(&:iznos).max
  end

  def prosjecna_cijena
    return nil if @cijene.empty?
    @cijene.map(&:iznos).sum / @cijene.size
  end

  def to_s
    "Naziv: #{@naziv}\nTrgovina: (#{@trgovina})\nCijena: #{trenutna_cijena} EUR\nLink: #{@url}"
  end

  def to_h
    {
      naziv: @naziv,
      trgovina: @trgovina,
      url: @url,
      cijene: @cijene.map(&:to_h)
    }
  end

  def self.from_h(hash)
    proizvod = new(
      naziv: hash[:naziv],
      trgovina: hash[:trgovina],
      url: hash[:url]
    )

    hash[:cijene].each do |c|
      proizvod.dodaj_cijenu(Cijena.from_h(c))
    end

    proizvod
  end
end

