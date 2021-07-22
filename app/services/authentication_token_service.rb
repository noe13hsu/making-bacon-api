class AuthenticationTokenService
    HMAC_SECRET = 'my$ecretK3y'
    ALGORITHM_TYPE = 'HS256'

    def self.call(user_id)
        payload = {user_id: user_id, exp: Time.now.to_i + 4 * 3600 }

        JWT.encode payload, HMAC_SECRET, ALGORITHM_TYPE
    end
end