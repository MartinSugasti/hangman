class String
  # styles
  def bold
    "\e[1m#{self}\e[22m"
  end

  def underline
    "\e[4m#{self}\e[24m"
  end

  def blink
    "\e[5m#{self}\e[25m"
  end
end
