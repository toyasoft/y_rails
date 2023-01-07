module Mutations
  class Signin < BaseMutation
    field :user, Types::UserType, null: true
    field :user_token, String, null: true

    argument :email, String, required: true
    argument :password, String, required: true
    
    def resolve(**args)
      user = User.find_by(email: args[:email])

      raise GraphQL::ExecutionError, "認証エラーです" unless user && user.authenticate(args[:password])
      {
        user: user,
        user_token: JsonWebToken.encode({
          id: user.id,
          email: user.email,
          type: "user",
          exp: (Time.zone.now + 24.hour).to_i
        })
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
