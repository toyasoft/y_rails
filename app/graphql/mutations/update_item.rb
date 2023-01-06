module Mutations
  class UpdateItem < BaseMutation
    field :item, Types::ItemType, null: false

    argument :id, ID, required: true
    argument :name, String, required: true
    argument :point, Integer, required: true

    def resolve(**args)
      raise CustomError::Unauthorized if context[:current_admin].nil? && context[:current_user].nil?
      item = Item.where(id: args[:id], del: 0).first
      item.update!(
        name: args[:name].nil? ? item.name : args[:name],
        point: args[:point].nil? ? website.point : args[:point],
      )
      return {
        item: item,
        errors: []
      }
    end
  end
end
