module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    argument :email, String, required: true
    argument :password, String, required: false

    def resolve(**args)

      
      user = User.create!(
        email: args[:email],
        password: args[:password]
      )
      {
        user: user
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
