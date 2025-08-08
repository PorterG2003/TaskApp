class Ui::Card < ApplicationComponent
  def initialize(
    title: nil,
    subtitle: nil,
    glass: false,
    padding: :md,
    **attrs
  )
    @title = title
    @subtitle = subtitle
    @glass = glass
    @padding = padding
    @attrs = attrs
  end

  private

  attr_reader :title, :subtitle, :glass, :padding, :attrs

  def card_classes
    base_classes = "rounded-xl border component-shadow"
    
    # Glass effect or solid background
    background_styles = glass ? glass_classes(intensity: :heavy) : "bg-white border-gray-200"
    
    # Padding
    padding_styles = case padding
    when :sm then "p-4"
    when :md then "p-6"
    when :lg then "p-8"
    else "p-6"
    end
    
    class_names(base_classes, background_styles, padding_styles, attrs[:class])
  end

  def header_classes
    "mb-4"
  end

  def title_classes
    "text-lg font-semibold text-gray-900"
  end

  def subtitle_classes
    "text-sm text-gray-600 mt-1"
  end
end 