Env = {
  :+      => ->(a, b) { a + b },
  :quote  => ->(*a)   { a.flatten 1 },
  :eq?    => ->(a, b) { a == b },
  :atom?  => ->(a)    { !a.is_a? Array },
  :list?  => ->(a)    { a.is_a? Array }
}

def read
  print "> "
  exp = []
  begin
    Kernel.eval("exp = " + gets.chomp.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop)
  rescue Exception
    puts "There are mismatched parentheses."
    exit
  end
  #puts "parsed to \"#{exp}\""
  exp
end

def eval exp
  head, *rest = exp
  #puts "got '#{head}' as head and '#{rest.inspect}' as rest"

  rest.map! { |i| i.is_a?(Array) ? eval(i) : i }
  Env[head].call *rest
end

loop {
  print(eval(read), "\n")  # authentic repl
}
