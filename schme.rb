Env = {
  :eq?    => ->(a, b) { a == b },
  :atom?  => ->(a)    { !a.is_a? Array },
  :list?  => ->(a)    { a.is_a? Array }
}
%w(+ - * /).each { |op| Env[op.to_sym] = ->(*a) { a.reduce(op.to_sym) } }

def read
  print "> "
  exp = gets.chomp.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop
  ast = Kernel.eval(exp)
  ast
rescue SyntaxError
  print "Syntax Error"
  return []
end

def eval exp
  return if exp == []
  head, *rest = exp
  rest.map! { |i| i.is_a?(Array) ? eval(i) : i }
  if Env.has_key?(head)
    Env[head].call(*rest)
  else
    print "Unknown operator \"#{head}\""
  end
end

def print(str)
  puts str
end

loop { print(eval(read)) } # authentic repl

