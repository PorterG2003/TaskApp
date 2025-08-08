class Ui::Icon < ApplicationComponent
  def initialize(name:, size: :md, style: :solid, **attrs)
    @name = name
    @size = size
    @style = style
    @attrs = attrs
  end

  private

  attr_reader :name, :size, :style, :attrs

  def icon_classes
    base_classes = "fa-#{name}"
    size_classes = size_classes_for(size)
    style_classes = style_classes_for(style)
    
    [base_classes, size_classes, style_classes, attrs[:class]].compact.join(" ")
  end

  def size_classes_for(size)
    case size
    when :xs then "text-xs"
    when :sm then "text-sm"
    when :md then "text-base"
    when :lg then "text-lg"
    when :xl then "text-xl"
    when :2xl then "text-2xl"
    else "text-base"
    end
  end

  def style_classes_for(style)
    case style
    when :solid then "fas"
    when :regular then "far"
    when :light then "fal"
    when :duotone then "fad"
    when :brands then "fab"
    else "fas"
    end
  end
end 