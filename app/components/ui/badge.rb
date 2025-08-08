class Ui::Badge < ApplicationComponent
  def initialize(
    text: nil,
    variant: :default,
    size: :md,
    glass: false,
    **attrs
  )
    @text = text
    @variant = variant
    @size = size
    @glass = glass
    @attrs = attrs
  end

  private

  attr_reader :text, :variant, :size, :glass, :attrs

  def badge_classes
    base_classes = "inline-flex items-center font-medium rounded-full component-transition"
    
    # Size classes
    size_styles = case size
    when :xs then "px-2 py-0.5 text-xs"
    when :sm then "px-2.5 py-0.5 text-sm"
    when :md then "px-3 py-1 text-sm"
    when :lg then "px-4 py-1.5 text-base"
    else "px-3 py-1 text-sm"
    end
    
    # Color classes (unless glass is enabled)
    color_styles = glass ? "" : color_classes(variant: variant, type: :solid)
    
    # Glass effect
    glass_styles = glass ? glass_classes(intensity: :heavy, tint: variant_to_tint) : ""
    
    class_names(base_classes, size_styles, color_styles, glass_styles, attrs[:class])
  end

  def variant_to_tint
    case variant
    when :primary then :blue
    when :success then :green
    when :warning then :amber
    when :danger then nil
    else nil
    end
  end
end 