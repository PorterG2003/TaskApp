class Ui::Input < ApplicationComponent
  def initialize(
    type: :text,
    placeholder: nil,
    value: nil,
    label: nil,
    error: nil,
    size: :md,
    glass: false,
    rows: nil,
    **attrs
  )
    @type = type
    @placeholder = placeholder
    @value = value
    @label = label
    @error = error
    @size = size
    @glass = glass
    @attrs = attrs
  end

  private

  attr_reader :type, :placeholder, :value, :label, :error, :size, :glass, :rows, :attrs

  def input_classes
    base_classes = "w-full border rounded-lg component-transition component-focus"
    
    # Size classes
    size_styles = size_classes(size: size, type: :padding)
    
    # Color classes (unless glass is enabled)
    color_styles = glass ? "" : "border-gray-300 bg-white text-gray-900 focus:border-blue-500 focus:ring-blue-500"
    
    # Glass effect
    glass_styles = glass ? glass_classes(intensity: :heavy) : ""
    
    # Error state
    error_styles = error ? "border-red-500 focus:border-red-500 focus:ring-red-500" : ""
    
    class_names(base_classes, size_styles, color_styles, glass_styles, error_styles, attrs[:class])
  end

  def label_classes
    class_names(
      "block text-sm font-medium mb-2",
      error ? "text-red-700" : "text-gray-700"
    )
  end

  def error_classes
    "mt-1 text-sm text-red-600"
  end
end 