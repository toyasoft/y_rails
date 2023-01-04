module Mutations
  class CreateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :name, String, required: true
    argument :price, Int, required: true
    argument :description, String, required: false

    def resolve(**args)
      raise CustomError::Unauthorized if context[:current_user].nil?
      item = Item.create!(
        name: args[:name],
        price: args[:price],
        description: args[:description],
      )
      return {
        item: item
      }
    end
  end
end
