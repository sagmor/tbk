module TBK
  def self.parse_key(name)
    OpenSSL::PKey::RSA.new( File.read(File.expand_path("../keys/#{}.pem",__FILE__)) )
  end
end
