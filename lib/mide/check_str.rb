class Mide::CheckStr
  @@reg = /^[httpsfile]+:\/{2,3}([0-9a-z\.\-:]+?):?[0-9]*?\//i

  def domain_plz(url)
    @@reg.match(url)
  end

  def domain?(url)
    if @@reg.match(url) then true else false end
  end
end
