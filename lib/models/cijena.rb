# frozen_string_literal: true
require 'time'

class Cijena
  attr_reader :iznos, :valuta, :datum_vrijeme

  def initialize(iznos, valuta = "EUR", datum_vrijeme = Time.now)
    @iznos = iznos.to_f
    @valuta = valuta
    @datum_vrijeme = datum_vrijeme
  end

  def to_h
    {
      iznos: @iznos,
      datum_vrijeme: @datum_vrijeme.iso8601
    }
  end

  def self.from_h(hash)
    new(hash[:iznos], Time.parse(hash[:datum_vrijeme]))
  end

  def to_s
    "#{@iznos} #{@valuta} (#{@datum_vrijeme})"
  end
end
