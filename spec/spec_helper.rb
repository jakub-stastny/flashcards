class Hash
  def except(*keys)
    (self.keys - keys).reduce(self.class.new) do |buffer, key|
      buffer.merge(key => self[key])
    end
  end
end
