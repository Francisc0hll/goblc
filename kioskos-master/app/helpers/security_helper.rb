module SecurityHelper
  def verify_signature(data_hash, totem)
    keys = data_hash.keys.sort
    data = ''
    keys.each do |key|
      data = data + key.to_s + data_hash[key].to_s if key.to_s != 'firma'
    end
    secret = ENV['MOC_SECRET'] || ''
    semilla = [totem.tid, secret].join
    secure_hash = OpenSSL::HMAC.digest('SHA256', semilla, data)
    signature = Base64.encode64(secure_hash)[0...-1]
    Rack::Utils.secure_compare(data_hash['firma'], signature)
  end
end
