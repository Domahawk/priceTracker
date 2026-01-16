# frozen_string_literal: true
# lib/storage/yaml_store.rb
require "yaml"
require "fileutils"
require_relative "../lib/models/proizvod"

class ProizvodStore
  FILE_PATH = "data/proizvodi.yml"

  def initialize
    FileUtils.mkdir_p("data")
  end

  def load
    return [] unless File.exist?(FILE_PATH)

    data = YAML.load_file(FILE_PATH, symbolize_names: true)

    return [] if data.nil?

    data.map { |hash| Proizvod.from_h(hash) }
  end

  def save(novi_proizvodi)
    postojeci = load
    spojeni = merge(postojeci, novi_proizvodi)
    File.write(FILE_PATH, spojeni.map(&:to_h).to_yaml)
  end

  private

  def merge(stari, novi)
    rezultat = stari.dup

    novi.each do |novi_proizvod|
      index = rezultat.find_index do |p|
        p.naziv == novi_proizvod.naziv && p.trgovina == novi_proizvod.trgovina
      end

      if index
        novi_proizvod.cijene.each do |c|
          rezultat[index].dodaj_cijenu(c)
        end
      else
        rezultat << novi_proizvod
      end
    end

    rezultat
  end
end
