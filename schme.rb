$env = {
  :eq?    => ->(a, b) { a == b },
  :atom?  => ->(a)    { !a.is_a? Array },
  :list?  => ->(a)    { a.is_a? Array },
  :set    => ->(a, b) { $env[a.to_sym] = b }
}
%w(+ - * /).each { |op| $env[op.to_sym] = ->(*a) { [a].map(&:transform_var); a.reduce(op.to_sym) } }

def transform_var(var)
  if var.is_a?(Symbol) and $env.has_key?(var)
    $env[var]
  else
    puts "Constant not found"
  end
end

def read
  Kernel.print "> "
  exp = gets.chomp.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop
  ast = Kernel.eval(exp)
rescue SyntaxError
  print "Syntax Error"
  return []
end

def eval exp
  return if exp == []
  head, *rest = exp
  rest.map! { |i| i.is_a?(Array)  ? eval(i) : i }
  if $env.has_key?(head)
    $env[head].call(*rest)
  else
    print "Unknown operator \"#{head}\""
  end
end

def print(str)
  puts str
end

loop { print(eval(read)) } # authentic repl

