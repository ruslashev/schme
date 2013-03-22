class Lirb
  attr_accessor :file, :exp

  def initialize newFile
    @file = newFile
  end
  
  def parse
    eval("@exp = " + @file.gsub(/([()])|([^() ]+)/) { |s| {"(" => "[", ")" => "],", $2 => "\""+$2.to_s+"\","}[s] }.gsub(/(,\])/, "]").chop)

    p exp
  end
end

l = Lirb.new "((quote 1 2) (+ 56 144) (test (awh) asdasgf))"
l.parse
