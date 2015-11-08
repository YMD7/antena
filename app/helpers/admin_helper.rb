module AdminHelper
  def controller_name_currenter(el, name)
    if name === controller_name
      '<li>'
    end
  end
end
