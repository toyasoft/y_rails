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
      raise GraphQL::ExecutionError, "自己出品の商品は購入できません" if item.user_id === context[:current_user].id
      raise GraphQL::ExecutionError, "ポイントが不足しています" if item.point > context[:current_user].point

      
      order = Order.create!(
        user_id: context[:current_user].id,
        item_id: item.id,
        point: item.point,
        buyer: context[:current_user].email,
        seller: item.user.email,
        name: item.name
      )
      buyer = User.find(context[:current_user].id)
      buyer.update(
        point: buyer.point - item.point
      )
      seller = User.find(item.user.id)
      seller.update(
        point: seller.point + item.point
      )
      {
        order: order,
        buyer: buyer,
        seller: seller
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
