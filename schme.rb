class Lirb
  def initialize newFile
    @file = newFile
    @exp = []

    @env = {
      :+ =>     ->(a, b) { a + b },
      quote:    ->(*a)   { a.flatten 1 },
      eq?:      ->(a, b) { a == b },
      atom?:    ->(a)    { !a.is_a? Array },
      list?:    ->(a)    { a.is_a? Array }
    }
  end
  
  def parse
    begin
      eval("@exp = " + @file.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop)
    rescue Exception
      puts "There are mismatched parentheses."
      exit
    end
    puts "parsed to \"#{@exp}\""
  end

  def evaluate exp=@exp
    head, rest = exp[0], exp[1..-1]
    puts "we got '#{head}' as head and '#{rest.inspect}' as rest"

    exp.map! do |t|
      print "#{t} is "
      case t
      when Symbol
        puts "a symbol."
        res = @env[head].call *rest
        puts "@env[#{head}].call(#{rest}) = #{res}"
        res
      when Array
        puts "an array."
        evaluate exp[1..-1]
      else
        puts "an atomic unit."
        exp
      end
    end

    #p exp.map! { |t|
    #  if t.is_a? Array
    #    puts "#{t} is an Array"
    #    if @env.has_key? t[0]
    #      puts "And #{t} is a function. Going deeper"
    #      t = evaluate t
    #    end
    #  else
    #    t
    #  end
    #}

    #res = @env[head].call *rest
    #puts "@env[#{head}].call(#{rest}) = #{res}"
    #res
  end
end

l = Lirb.new "(eq? (+ 1 1) 2)"
l.parse
p l.evaluate
