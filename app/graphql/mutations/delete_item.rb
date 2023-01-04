module Mutations
  class DeleteItem < BaseMutation
    field :item, Types::ItemType, null: true
    field :deleted_item_id, ID, null: false

    argument :id, ID, required: true

    def resolve(**args)
      raise GraphQL::ExecutionError, "認証できませんでした" if context[:current_user].nil?
      item = Item.find(args[:id])
      item.destroy!

      return {
        current_user: context[:current_user],
        deleted_website_id: args[:id],
        website: website,
        errors: []
      }
    end
  end
end
