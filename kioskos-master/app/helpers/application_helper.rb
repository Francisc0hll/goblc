module ApplicationHelper
  def format_rut(rut)
    rut = rut.delete('.-')
    root = rut[0..-2].gsub(/(\d)(?=(\d{3})+(?!\d))/, '\1.')
    "#{root}-#{rut.last}"
  end
end
