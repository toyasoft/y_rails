module Mutations
  class Signin < BaseMutation
    field :user, Types::UserType, null: true
    field :auth_token, String, null: true
    field :errors, [String], null: false

    argument :email, String, required: true
    argument :password, String, required: true
    
    def resolve(**args)
      user = User.find_by(email: args[:email])

      raise User.all.to_yaml
      raise GraphQL::ExecutionError.new("not authorized to create account for email:#{args[:email]}", extensions: { code: "UNAUTHORIZED"}) unless user && user.authenticate(args[:password])
      {
        user: user,
        auth_token: JsonWebToken.encode({
          user_id: user.id,
          exp: (Time.zone.now + 24.hour).to_i
        }),
        errors: []
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
