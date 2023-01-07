module Mutations
  class UpdateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :id, ID, required: true
    argument :name, String, required: true
    argument :point, Integer, required: true

    def resolve(**args)
      raise GraphQL::ExecutionError, "認証エラーです" if context[:current_user].nil?
      item = Item.where(del: 0).find(args[:id])
      item.update!(
        name: args[:name].nil? ? item.name : args[:name],
        point: args[:point].nil? ? website.point : args[:point],
      )
      return {
        item: item
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
