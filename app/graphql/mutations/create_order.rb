module Mutations
  class CreateOrder < BaseMutation
    field :order, Types::OrderType, null: false
    field :buyer, Types::UserType, null: false
    field :seller, Types::UserType, null: false
    field :errors, [String], null: false

    argument :itemId, ID, required: true

    def resolve(**args)

      raise GraphQL::ExecutionError, "認証エラーです" if context[:current_user].nil?
      item = Item.where(del: false).find(args[:itemId])
      
      order = Order.create!(
        user_id: context[:current_user].id,
        item_id: item.id,
        point: item.point,
        buyer: context[:current_user].email,
        seller: item.user.email,
        name: item.name
      )
      {
        order: order,
        buyer: {
          id: context[:current_user].id,
          email: context[:current_user].email,
          point: context[:current_user].point
        },
        seller: {
          id: item.user.id,
          email: item.user.email,
          point: item.user.point
        }
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
