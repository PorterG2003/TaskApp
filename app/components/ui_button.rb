class UI::Button < ViewComponent::Base
  # Variant options: :primary, :secondary, :success, :warning, :danger, :ghost
  # Size options: :sm, :md, :lg
  # Glass options: false, :light, :heavy
  # Tint options: nil, :blue, :purple, :green, :amber, :red
  
  def initialize(
    variant: :primary,
    size: :md,
    glass: false,
    tint: nil,
    href: nil,
    method: nil,
    data: {},
    class: nil,
    **attrs
  )
    @variant = variant
    @size = size
    @glass = glass
    @tint = tint
    @href = href
    @method = method
    @data = data
    @custom_class = binding.local_variable_get(:class)
    @attrs = attrs
  end

  private

  attr_reader :variant, :size, :glass, :tint, :href, :method, :data, :custom_class, :attrs

  def link?
    href.present?
  end

  def css_classes
    classes = [
      base_classes,
      variant_classes[variant],
      size_classes[size],
      glass_classes,
      tint_classes,
      custom_class
    ].compact.join(' ')
  end

  def base_classes
    "inline-flex items-center justify-center font-medium rounded-lg transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed"
  end

  def variant_classes
    {
      primary: "bg-blue-600 hover:bg-blue-700 text-white focus:ring-blue-500",
      secondary: "bg-gray-600 hover:bg-gray-700 text-white focus:ring-gray-500", 
      success: "bg-green-600 hover:bg-green-700 text-white focus:ring-green-500",
      warning: "bg-amber-600 hover:bg-amber-700 text-white focus:ring-amber-500",
      danger: "bg-red-600 hover:bg-red-700 text-white focus:ring-red-500",
      ghost: "bg-transparent hover:bg-gray-100 text-gray-700 border border-gray-300 focus:ring-gray-500"
    }
  end

  def size_classes
    {
      sm: "px-3 py-1.5 text-sm",
      md: "px-4 py-2 text-base",
      lg: "px-6 py-3 text-lg"
    }
  end

  def glass_classes
    return "" unless glass
    
    base_glass = case glass
    when :light
      "glass"
    when :heavy
      "glass-heavy"
    else
      "glass"
    end
    
    # Override background for glass effect
    glass_variant = case variant
    when :primary
      "text-blue-900 hover:bg-white/30"
    when :secondary
      "text-gray-900 hover:bg-white/30"
    when :success
      "text-green-900 hover:bg-white/30"
    when :warning
      "text-amber-900 hover:bg-white/30"
    when :danger
      "text-red-900 hover:bg-white/30"
    when :ghost
      "text-gray-700 hover:bg-white/30"
    end
    
    "#{base_glass} #{glass_variant}"
  end

  def tint_classes
    return "" unless glass && tint
    
    case tint
    when :blue
      "glass-blue"
    when :purple
      "glass-purple"
    when :green
      "glass-green"
    when :amber
      "glass-amber"
    when :red
      "glass-red"
    else
      ""
    end
  end

  def link_data
    return data unless method
    data.merge(turbo_method: method)
  end
end