# frozen_string_literal: true

class IsoLanguage
  TOP = %w[de el en es fr it nl pl pt ru sv tr].freeze

  def self.all
    I18n.t(:iso_639_1).invert.sort.to_h.values.map(&:to_s)
  end

  def self.top_list
    all.select { |key| TOP.include?(key) }
  end

  def self.rest_list
    all - TOP
  end

  def self.all_languagenames_with_iso
    IsoLanguage.all.map { |l| [I18n.t(l.to_s, scope: 'iso_639_1').capitalize, l] }
  end
end
