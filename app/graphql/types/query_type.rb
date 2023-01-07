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
      raise GraphQL::ExecutionError, "商品IDが無効です" unless id =~ /^[0-9]+$/
      Item.where(del: 0).find_by!(id: id)
    rescue => e
      raise GraphQL::ExecutionError, e
    end

    field :current_user, Types::UserType, null: false
    def current_user
      raise GraphQL::ExecutionError, "認証エラーです" unless context[:current_user]
      context[:current_user]
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
