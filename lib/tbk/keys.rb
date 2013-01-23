module TBK
  def self.parse_key(name)
    OpenSSL::PKey::RSA.new( File.read(File.expand_path("../keys/#{name}.pem",__FILE__)) )
  end
end
