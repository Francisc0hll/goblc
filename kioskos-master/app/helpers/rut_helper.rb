module RutHelper
  def add_dots_and_dashes(rut)
    *numero, digito_verificador = *rut.chars
    # This looks really ugly
    # TODO: Refactor?
    dashed_number =
      numero.reverse.each_slice(3).map do |chunk|
        next '.' + chunk.reverse.join if chunk.size > 2
        chunk.reverse.join
      end.reverse.join
    "#{dashed_number}-#{digito_verificador}"
  end

  def add_dashes(rut)
    *numero, digito_verificador = *rut.chars
    "#{numero.join()}-#{digito_verificador}"
  end
end
