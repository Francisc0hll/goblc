class SIMPLE
  BASE_URL = ENV['SIMPLE_URL']

  def self.get_procedure(id, rut)
    conn = Faraday.new(url: "#{BASE_URL}/#{id}", ssl: { verify: false }, request: [:json])
    response = conn.post do |req|
      req.body = { rut: SIMPLE.simple_rut_format(rut) }
      req.headers['cache-control'] = 'no-cache'
    end
    JSON.parse(response.body).with_indifferent_access
  rescue => e
    puts "error is #{e}"
    Rollbar.error(e)
    {}
  end

  def self.simple_rut_format(rut)
    rut.to_s.delete('-').insert(-2, '-')
  end
end
