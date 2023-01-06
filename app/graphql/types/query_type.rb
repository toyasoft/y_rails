module Types
  class QueryType < Types::BaseObject

    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :items, [Types::ItemType], null: false
    def items
      Item.where(del: 0)
    end

    field :item, Types::ItemType, null: false do
      argument :id, ID, required: true
    end
    def item(id:)
      Item.where(del: 0).find_by(id: args[:id])
    end

    field :current_user, Types::UserType, null: false
    def current_user
      current_user
    end

    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end
    def user(id:)
      User.find(id)
    end

    field :orders, [Types::OrderType], null: false
    def orders
      Order.all
    end
  end
end
