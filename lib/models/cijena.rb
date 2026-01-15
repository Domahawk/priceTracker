# frozen_string_literal: true

class Cijena
  attr_reader :iznos, :valuta, :datum_vrijeme

  def initialize(iznos, valuta = "EUR", datum_vrijeme = Time.now)
    @iznos = iznos.to_f
    @valuta = valuta
    @datum_vrijeme = datum_vrijeme
  end

  def to_s
    "#{@iznos} #{@valuta} (#{@datum_vrijeme})"
  end
end
