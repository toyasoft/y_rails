# lib/json_web_token.rb
class JsonWebToken

  class << self
    def encode(payload)
      # 認証トークンエンコード
      JWT.encode(payload, Rails.application.credentials.config[:secret_key_base])
    end

    def decode(token)
      # 認証トークンデコード
      HashWithIndifferentAccess.new(
        JWT.decode(token, Rails.application.credentials.config[:secret_key_base])[0]
      )
    end

    # リフレッシュトークン
    def set_admin_refresh_token(admin_id)
      token = SecureRandom.hex
      crypted_token = Digest::SHA256.hexdigest(token)
      RefreshToken.create(crypted_token: crypted_token, admin_id: admin_id)
      token
    end

    def set_user_refresh_token(user_id)
      token = SecureRandom.hex
      crypted_token = Digest::SHA256.hexdigest(token)
      RefreshToken.create(crypted_token: crypted_token, user_id: user_id)
      token
    end

    def set_website_refresh_token(website_id)
      token = SecureRandom.hex
      crypted_token = Digest::SHA256.hexdigest(token)
      RefreshToken.create(crypted_token: crypted_token, website_id: website_id)
      token
    end
  end
  
end