# Base component class that all our components inherit from
class ApplicationComponent < ViewComponent::Base
  private

  # Helper method to merge CSS classes
  def class_names(*classes)
    classes.compact.join(" ")
  end

  # Glass effect utilities
  def glass_classes(intensity: :medium, tint: nil)
    base = case intensity
           when :light then "backdrop-blur-sm bg-white/30"
           when :medium then "backdrop-blur-md bg-white/20"
           when :heavy then "backdrop-blur-xl bg-white/10"
           else "backdrop-blur-md bg-white/20"
           end

    tint_class = case tint
                 when :blue then "bg-blue-500/10"
                 when :purple then "bg-purple-500/10"
                 when :green then "bg-green-500/10"
                 when :amber then "bg-amber-500/10"
                 when :none, nil then ""
                 else ""
                 end

    border = "border border-white/20"
    
    "#{base} #{tint_class} #{border}".strip
  end

  # Design system color utilities
  def color_classes(variant: :primary, type: :solid)
    colors = {
      primary: {
        solid: "bg-blue-600 text-white hover:bg-blue-700",
        outline: "border-blue-600 text-blue-600 hover:bg-blue-50",
        ghost: "text-blue-600 hover:bg-blue-50"
      },
      secondary: {
        solid: "bg-gray-600 text-white hover:bg-gray-700",
        outline: "border-gray-600 text-gray-600 hover:bg-gray-50",
        ghost: "text-gray-600 hover:bg-gray-50"
      },
      success: {
        solid: "bg-green-600 text-white hover:bg-green-700",
        outline: "border-green-600 text-green-600 hover:bg-green-50",
        ghost: "text-green-600 hover:bg-green-50"
      },
      warning: {
        solid: "bg-amber-600 text-white hover:bg-amber-700",
        outline: "border-amber-600 text-amber-600 hover:bg-amber-50",
        ghost: "text-amber-600 hover:bg-amber-50"
      },
      danger: {
        solid: "bg-red-600 text-white hover:bg-red-700",
        outline: "border-red-600 text-red-600 hover:bg-red-50",
        ghost: "text-red-600 hover:bg-red-50"
      }
    }

    colors.dig(variant, type) || colors.dig(:primary, :solid)
  end

  # Size utilities
  def size_classes(size: :md, type: :padding)
    sizes = {
      padding: {
        xs: "px-2 py-1 text-xs",
        sm: "px-3 py-1.5 text-sm",
        md: "px-4 py-2 text-sm",
        lg: "px-6 py-3 text-base",
        xl: "px-8 py-4 text-lg"
      },
      spacing: {
        xs: "space-y-1",
        sm: "space-y-2",
        md: "space-y-4",
        lg: "space-y-6",
        xl: "space-y-8"
      }
    }

    sizes.dig(type, size) || sizes.dig(type, :md)
  end
end