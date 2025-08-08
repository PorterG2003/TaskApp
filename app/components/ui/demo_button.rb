# Example component to demonstrate the framework
class Ui::DemoButton < ApplicationComponent
  def initialize(text: "Click me", variant: :primary, size: :md, glass: false, **attrs)
    @text = text
    @variant = variant
    @size = size
    @glass = glass
    @attrs = attrs
  end

  private

  attr_reader :text, :variant, :size, :glass, :attrs

  def css_classes
    base_classes = "font-medium rounded-lg component-transition component-focus cursor-pointer inline-flex items-center justify-center"
    
    # Size classes
    size_styles = size_classes(size: size, type: :padding)
    
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
    when :danger then nil  # Red tint would be too harsh
    else nil
    end
  end
end