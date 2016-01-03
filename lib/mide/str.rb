module Mide::Str
  @@reg = /^(https|http|file):\/{2,3}([0-9a-z\.\-:]+)/i

  def self.to_domain(url)
    res = @@reg.match(url)
    if res then res[2] else nil end
  end

  def self.domain?(url)
    if @@reg.match(url) then true else false end
  end
end
