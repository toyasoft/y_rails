module Types
  class MutationType < Types::BaseObject
    field :delete_item, mutation: Mutations::DeleteItem
    field :update_item, mutation: Mutations::UpdateItem
    field :create_item, mutation: Mutations::CreateItem
    field :signin, mutation: Mutations::Signin
    field :create_user, mutation: Mutations::CreateUser

  end
end
