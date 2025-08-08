class Ui::Avatar < ApplicationComponent
  def initialize(
    src: nil,
    alt: nil,
    fallback: nil,
    size: :md,
    glass: false,
    **attrs
  )
    @src = src
    @alt = alt
    @fallback = fallback
    @size = size
    @glass = glass
    @attrs = attrs
  end

  private

  attr_reader :src, :alt, :fallback, :size, :glass, :attrs

  def avatar_classes
    base_classes = "inline-block rounded-full component-transition"
    
    # Size classes
    size_styles = case size
    when :xs then "w-6 h-6"
    when :sm then "w-8 h-8"
    when :md then "w-10 h-10"
    when :lg then "w-12 h-12"
    when :xl then "w-16 h-16"
    else "w-10 h-10"
    end
    
    # Glass effect
    glass_styles = glass ? glass_classes(intensity: :heavy) : ""
    
    class_names(base_classes, size_styles, glass_styles, attrs[:class])
  end

  def fallback_classes
    base_classes = "flex items-center justify-center w-full h-full rounded-full font-medium text-gray-900"
    
    # Size-based text classes
    text_styles = case size
    when :xs then "text-xs"
    when :sm then "text-sm"
    when :md then "text-sm"
    when :lg then "text-base"
    when :xl then "text-lg"
    else "text-sm"
    end
    
    # Background color
    bg_styles = "bg-gray-500"
    
    class_names(base_classes, text_styles, bg_styles)
  end

  def has_image?
    src.present?
  end
end 