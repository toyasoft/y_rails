module Mutations
  class CreateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :name, String, required: true
    argument :point, Int, required: true

    def resolve(**args)
      raise CustomError::Unauthorized if context[:current_user].nil?
      item = Item.create!(
        name: args[:name],
        point: args[:point],
      )
      return {
        item: item
      }
    end
  end
end
