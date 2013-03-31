class Lirb
  def initialize newFile
    @file = newFile
    @exp = []

    @env = {
      :+      => ->(a, b) { a + b },
      :quote  => ->(*a)   { a.flatten 1 },
      :eq?    => ->(a, b) { a == b },
      :atom?  => ->(a)    { !a.is_a? Array },
      :list?  => ->(a)    { a.is_a? Array }
    }
  end
  
  def parse
    begin
      eval("@exp = " + @file.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop)
    rescue Exception
      puts "There are mismatched parentheses."
      exit
    end
    #puts "parsed to \"#{@exp}\""
  end

  def evaluate exp=@exp
    head, *rest = exp
    #puts "got '#{head}' as head and '#{rest.inspect}' as rest"

    rest.map! { |i| i.is_a?(Array) ? evaluate(i) : i }
    @env[head].call *rest
  end
end

l = Lirb.new "(eq? (+ 1 1) 2)"
l.parse
p l.evaluate
