module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    argument :name, String, required: true
    argument :email, String, required: true
    argument :password, String, required: false

    def resolve(**args)

      raise args.to_yaml
      
      user = User.create!(
        name: args[:name],
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
