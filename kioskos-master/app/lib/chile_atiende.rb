class ChileAtiende

  TOKEN = ENV['CHILEATIENDE_TOKEN']
  BASE_URL = 'https://www.chileatiende.gob.cl'.freeze
  NEWLINE_REPLACEMENT = 'this_is_a_newline_character'.freeze

  def self.get_procedure(id)
    conn = Faraday.new(url: BASE_URL)
    response = conn.get "/api/fichas/#{id}?access_token=#{TOKEN}", type: 'JSON'
    filter_chile_atiende_response(JSON.parse(response.body)['ficha'])
  rescue => e
    puts e
    Rollbar.error(e)
    {}
  end

  def self.search_procedures(max_results = 6, search_term = nil, next_step = nil)
    conn = Faraday.new(url: BASE_URL)
    response = conn.get '/api/fichas?query='+"#{search_term}"+'&access_token='+"#{TOKEN}",type: 'JSON',
                                                                                          maxResults: max_results,
                                                                                          pageToken: next_step                                     
                                  
    hashed_response = JSON.try(:parse, response.body)  
    hashed_response['fichas']['items']['ficha']    
    
  rescue => e
    puts e
    []
  end

  def self.filter_chile_atiende_response(hash)
    hash.keys.each do |k|
      next unless hash[k].is_a? String
      replace_newlines_in(hash[k], NEWLINE_REPLACEMENT)
      hash[k] = tags_to_replace.reduce(hash[k]) do |result, tag|
        send("replace_#{tag}", result)
      end
      reinstate_newlines_in(hash[k], NEWLINE_REPLACEMENT)
    end
    hash
  end

  def self.tags_to_replace
    %w[
      mensaje
      documentos_requeridos
      marco_legal
      audiovisual
      pasos
      contenido
      canal
      campo
    ]
  end

  def self.replace_mensaje(string)
    field_types = %w[reloj descarga consulta calendario
                     alerta destacado documento decreto]
    tag = tag_with_field_types('mensaje', *field_types)
    regex = get_regex(tag)
    replace_tag_with_contents(regex, string)
  end

  def self.replace_documentos_requeridos(string)
    field_types = %w[doc ppt pdf xls otro]
    tag = tag_with_field_types('doc', *field_types)
    regex = get_regex(tag)
    replace_tag_with_contents(regex, string)
  end

  def self.replace_marco_legal(string)
    regex = get_regex('marco_legal')
    replace_tag_with_contents(regex, string)
  end

  def self.replace_audiovisual(string)
    valid_values = %w[infografia youtube vimeo podcaster]
    tag = any_of_these(*valid_values)
    regex = get_regex(tag)
    substitution_logic = audiovisual_substitution_logic(regex)
    replace_tag_with_contents(regex, string, substitution_logic)
  end

  def self.audiovisual_substitution_logic(regex)
    lambda do |group|
      resource_id = regex.match(group)[1]
      return audiovisual_link_addresses['youtube'] + resource_id if group.include? 'youtube'
      return audiovisual_link_addresses['vimeo'] + resource_id if group.include? 'vimeo'
      return audiovisual_link_addresses['podcaster'] + resource_id if group.include? 'podcaster'
      return audiovisual_link_addresses['infografia'] + resource_id if group.include? 'infografia'
    end
  end

  def self.audiovisual_link_addresses
    {
      'youtube' => 'https://www.youtube.com/watch?v=',
      'vimeo' => 'https://vimeo.com/',
      'podcaster' => '',
      'infografia' => ''
    }
  end

  def self.replace_pasos(string)
    regex = get_regex('paso')
    replace_tag_with_contents(regex, string)
  end

  def self.replace_contenido(string)
    regex = get_regex('contenido')
    replace_tag_with_contents(regex, string)
  end

  def self.replace_canal(string)
    field_types = %w[online callcenter oficina oficinamovil tramites]
    tag = tag_with_field_types('canal', *field_types)
    regex = get_regex(tag)
    replace_tag_with_contents(regex, string)
  end

  def self.replace_campo(string)
    field_types = %w[cc_observaciones beneficiarios vigencia doc_requeridos
                     cost marco_legal plazo informacion_multimedia]
    tag = tag_with_field_types('campo', *field_types)
    regex = get_regex(tag)
    replace_tag_with_contents(regex, string)
  end

  def self.any_of_these(*args)
    keywords = args.join('|')
    '(?:' << keywords << ')'
  end

  def self.tag_with_field_types(tag, *field_types)
    # Do note that the string MUST be single quoted for the escape characters
    # to work, hence shoveling instead of using string interpolation
    tag << '\[' << any_of_these(*field_types) << '\]'
  end

  def self.replace_newlines_in(string, newline_replacement)
    string.gsub!("\n", newline_replacement)
  end

  def self.reinstate_newlines_in(string, newline_replacement)
    string.gsub!(newline_replacement, "\n")
  end

  def self.get_regex(tag)
    /{{#{tag}:(.*?)}}/
  end

  # Replace a tag regex ("regex") in a string ("string") according to
  # "substitution", which can be a string, a hash o a block (since it's done
  # with gsub). Note that blocks to be used on gsub must be passed as procs
  # You can also pass a block to do something with the new string that is output
  # after performing the substitution
  def self.replace_tag_with_contents(regex, string, substitution = '\\1')
    new_string = if substitution.is_a?(Proc)
                   string.gsub(regex, &substitution)
                 else
                   string.gsub(regex, substitution)
                 end
    return new_string unless block_given?
    yield new_string
  end
end
