Env = {
  :eq?    => ->(a, b) { a == b },
  :atom?  => ->(a)    { !a.is_a? Array },
  :list?  => ->(a)    { a.is_a? Array }
}
%w(+ - * /).each { |op| Env[op.to_sym] = ->(*a) { a.reduce(op.to_sym) } }

def read
  print "> "
  exp = []
  Kernel.eval("exp = " + gets.chomp.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop)
  p exp
  exp
rescue Interrupt => e # Ctrl+C
  exit
rescue Exception => e
  print "Syntax Error"
end

def eval exp
  head, *rest = exp
  rest.map! { |i| i.is_a?(Array) ? eval(i) : i }
  if Env.has_key?(head)
    Env[head].call(*rest)
  else
    puts "Unknown identifier \"#{head}\""
    exit 2
  end
end

loop { print(eval(read), "\n") } # authentic repl
