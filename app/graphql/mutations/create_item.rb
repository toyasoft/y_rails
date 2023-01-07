module Mutations
  class CreateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :name, String, required: true
    argument :point, Int, required: true

    def resolve(**args)

      raise GraphQL::ExecutionError, "認証エラーです" if context[:current_user].nil?
      item = Item.create!(
        name: args[:name],
        point: args[:point],
        user_id: context[:current_user].id
      )

      return {
        item: item
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
