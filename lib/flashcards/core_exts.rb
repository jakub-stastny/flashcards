# Yeah, I know what do you think about it, but then again ... what the hell.
class Array
  def join_with_and(xxx = 'and', delimiter = ', ')
    return self[0] if self.length == 1
    "#{self[0..-2].join(delimiter)} #{xxx} #{self[-1]}"
  end
end

class String
  def titlecase
    "#{self[0].upcase}#{self[1..-1]}"
  end
end

# NOTE: The recursion is to add support for parsing nesting, such as in <green>1<yellow>2</yellow>.</green>
# TODO: Nesting still doesn't work, i. e. in <green>✔︎ <yellow>Todavía</yellow> is indeed <yellow>still</yellow>. </green>
# That's because we don't know which scope are we in (what tags are open).
def colourise(string, options = Hash.new)
  result = string.gsub(/<([^>]+)>(.+?)<\/\1>/m) do |match|
    methods = $1.split('.')
    methods.push(:bold) if options[:bold]
    methods.reduce($2) do |result, method|
      result.send(method)
    end
  end

  result.match(/<([^>]+)>(.+?)<\/\1>/m) ? colourise(result) : result
end
