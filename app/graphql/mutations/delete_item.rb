module Mutations
  class DeleteItem < BaseMutation
    field :item, Types::ItemType, null: true
    field :deleted_item_id, ID, null: false

    argument :id, ID, required: true

    def resolve(**args)
      raise GraphQL::ExecutionError, "認証できませんでした" if context[:current_user].nil?
      item = Item.find(args[:id])
      item.update!(del: 1)

      return {
        deleted_item_id: args[:id],
        errors: []
      }
    end
  end
end
