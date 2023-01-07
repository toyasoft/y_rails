module Mutations
  class DeleteItem < BaseMutation
    field :item, Types::ItemType, null: true
    field :deleted_item_id, ID, null: false

    argument :id, ID, required: true

    def resolve(**args)
      raise GraphQL::ExecutionError, "認証エラーです" if context[:current_user].nil?
      item = Item.where(del: false).find(args[:id])
      item.update!(del: true)

      return {
        deleted_item_id: args[:id],
        errors: []
      }
    rescue => e
      raise GraphQL::ExecutionError, e
    end
  end
end
