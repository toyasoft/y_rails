require 'rails_helper'

describe Mutations::CreateItem do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($object: ItemAttributes!) {
        createItem(
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
    it 'create an item and return object' do
      object = {
        userId: user.id,
        name: "商品1",
        price: 1000
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { object: object })
      expect(result.dig('data', 'createItem', 'item')).not_to be_blank
      expect(Item.count).to eq 1
      expect(Item.first).to have_attributes(
        user_id: user.id,
        name: '商品1',
        price: 1000
      )
    end
  end

end
