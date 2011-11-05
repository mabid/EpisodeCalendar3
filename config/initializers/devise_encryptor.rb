module Devise
  module Encryptors
    class RestfulAuthentication < Base
      def self.digest(password, stretches, salt, pepper)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end
    end
  end
end