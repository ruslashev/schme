Env = {
  :eq?    => ->(a, b) { a == b },
  :atom?  => ->(a)    { !a.is_a? Array },
  :list?  => ->(a)    { a.is_a? Array }
}
%w(+ - * /).each { |op| Env[op.to_sym] = ->(*a) { a.reduce(op.to_sym) } }

def read
  print "> "
  exp = []
  begin
    Kernel.eval("exp = " + gets.chomp.gsub(/([()])|([^()\d ]+)|(\d+)/) { |s| {"(" => "[", ")" => "]", $2 => ":"+$2.to_s, $3 => $3.to_i.to_s}[s]+(s == "(" ? " " : ",") }.gsub(/,\]/, "]").chop)
  rescue Interrupt      # Ctrl+C
    puts "", "Bye!"
    exit
  rescue SyntaxError    # (() for example
    puts "Messed up Parentheses!"
    exit
  rescue StandardError  # The rest, also Ctrl+D
    puts "", "Something gone wrong!"
    exit
  end
  exp
end

def eval exp
  head, *rest = exp
  rest.map! { |i| i.is_a?(Array) ? eval(i) : i }
  Env[head].call(*rest) if Env.has_key?(head)
end

loop {
  print(eval(read), "\n")  # authentic repl
}
