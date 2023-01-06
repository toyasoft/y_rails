module Mutations
  class CreateOrder < BaseMutation
    field :order, Types::OrderType, null: false
    field :errors, [String], null: false

    argument :item_id, String, required: true

    def resolve(**args)

      item = Item.find(args[:item_id])
      
      order = Order.create!(
        user_id: user.id,
        item_id: item.id,
        point: item.point,
        buyer: user.email,
        seller: item.user.email,
        name: item.name
      )
      {
        order: order
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
