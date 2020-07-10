class LineTokens
  attr_reader :tokens

  def initialize(line)
    @line = line
    @start = 0
    @curr = 0
    @tokens = Array.new
  end
  def num_bullets
    return 0 if @tokens.empty?
    if @tokens[0].type == :BULLET1
      return 1
    elsif @tokens[0].type == :BULLET2
      return 2
    end
    return 0
  end
  def bullet_end_tag(prev_line_num_bullets)
    if prev_line_num_bullets == 1
      return "</ul>"
    elsif prev_line_num_bullets == 2
      return "</ul></ul>"
    else
      return ""
    end
  end

  def to_html(previous_line_num_bullets)
    result = ""
    end_tag = ""
    if @tokens.empty? 
      return bullet_end_tag(previous_line_num_bullets)
    end

    if previous_line_num_bullets > 0
      result = bullet_end_tag(previous_line_num_bullets)
    end

    skip_first_token = true

    case @tokens[0].type
    when :H1
      result = "<h1>"
      end_tag = "</h1>"
    when :H2
      result = "<h2>"
      end_tag = "</h2>"
    when :H3
      result = "<h3>"
      end_tag = "</h3>"
    when :H4
      result = "<h4>"
      end_tag = "</h4>"
    when :H5
      result = "<h5>"
      end_tag = "</h5>"
    when :BULLET1
      result = nil
      if previous_line_num_bullets == 0
        result = "<ul>"
      end
      result = "#{result}<li>"
      end_tag = "</li>"
    when :BULLET2
      result = nil
      if previous_line_num_bullets != 2
        result = "<ul>"
      end
      result = "#{result}<li>"
      end_tag = "</li>"
    when :TEXT
      skip_first_token = false 
    end
    @tokens.each_with_index do |token, i|
      next if skip_first_token and i == 0
      result = "#{result}#{token.value}"
    end
    result = "#{result}#{end_tag}"
    result
  end
  def scan_tokens
    while !end_of_line?
      @start = @curr
      scan_token()
    end
    @tokens
  end
  def scan_token
    char = advance()
    #puts char
    case char
    when "h"
      header()
    when "*"
      bullet()
    else
      text()
    end
  end
  def advance
    @curr = @curr + 1
    return @line[@curr-1]
  end
  def peek
    if end_of_line? 
      return :EOL
    end
    return @line[@curr]
  end
  def peek_next
    if @curr + 1 >= @line.size
      return :EOL
    end
    return @line[@curr + 1]
  end
  def is_numeric?(o)
    true if Integer(o) rescue false
  end
  def header
    type = nil
    if peek() != :EOL
      if is_numeric?(peek())
        if peek_next() == '.'
          case peek().to_i
          when 1
            type = :H1
          when 2
            type = :H2
          when 3
            type = :H3
          when 4
            type = :H4
          else
            # can only use up to h5. in this limited markdown subset
            type = :H5
          end
          advance()
          advance()
        end
      end
    end

    value = @line[@start, @curr]
    add_token(type, value)
  end
  def bullet
    type = nil
    if peek() != :EOL
      if peek() == '*'
        type = :BULLET2
        advance()
      else
        type = :BULLET1
      end
    end

    value = @line[@start, @curr]
    add_token(type, value)
  end
  def text
    while !end_of_line?
      advance()
    end

    value = @line[@start, @curr]
    add_token(:TEXT, value)
  end
  def add_token(type, value)
    #puts "add_token: #{type}  #{value}"
    token = Token.new(type, value)
    @tokens << token
  end
  def end_of_line?
    @curr >= @line.size
  end
end

class Scan
  def initialize(lines)
    @lines = lines
    @line_tokens_list = Array.new
  end
  def scan_tokens
    tokens = nil
    @lines.each do |line|
      line.chomp!
      line_tokens = LineTokens.new(line)
      line_tokens.scan_tokens
      @line_tokens_list << line_tokens
    end
  end
  def end_of_lines?
    @line >= @lines.size
  end
  def to_html
    result = ""
    previous_line_num_bullets = 0
    @line_tokens_list.each_with_index do |line_tokens, i|
      previous_lines_tokens = nil
      result = "#{result}#{line_tokens.to_html(previous_line_num_bullets)}\n"
      previous_line_num_bullets = line_tokens.num_bullets
    end
    return result
  end
end

class LineToken
  def initialize
    @tokens = Array.new
  end
  def add(token)
    @tokens << token
  end
end
class Token
  attr_reader :type, :value

  def initialize(type, value=nil) 
    @type = type
    @value = value
  end
  def to_s
    "#{@type}:#{@value}"
  end
end
