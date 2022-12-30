module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    field :items, [Types::ItemType], null: false
    def items
      Item.all
    end

    field :item, Types::ItemType, null: false do
      argument :id, Int, required: false
    end
    def item(id:)
      Item.find(id)
    end

    field :user, Types::UserType, null: false do
      argument :id, Int, required: false
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
