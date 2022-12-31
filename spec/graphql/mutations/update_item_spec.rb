require 'rails_helper'

describe Mutations::UpdateItem do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($object: ItemAttributes!) {
        updateItem(
          input: {
            object: $object
          }
        ){
          item {
            id
            user{id}
            name
            price
          }
        }
      }
    GRAPHQL
  }

  context 'nomally' do
    it 'update an item and return object' do
      object = {
        id: item.id,
        userId: user.id,
        name: "updated001-#{item.id}-#{item.name}",
        price: item.price
      }

      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { object: object })
      expect(result.dig('data', 'updateItem', 'item')).not_to be_blank
      expect(Item.count).to eq 1
      expect(Item.find_by(id: item.id)).to have_attributes(
        id: item.id,
        user_id: user.id,
        name: "updated001-#{item.id}-#{item.name}",
        price: item.price
      )
    end
  end
  context 'if there is no update target record' do
    it 'raise execution error' do
      object = {
        id: 0,
        userId: user.id,
        name: "update Item",
        price: 1000
      }

      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { object: object })
      expect(result.dig('data', 'updateItem')).to be_nil
      expect(result.dig('errors', 0, 'message')).to eq("item not found with id:0")
    end
  end

end
