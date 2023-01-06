require 'rails_helper'

describe Types::QueryType do
  let!(:group) { create(:group) }
  let!(:group_in_the_same_company) { create(:group, company: group.company) }
  let!(:group_in_different_company) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:order) { create(:order, group: group) }
  let!(:account_in_the_same_group) { create(:order, group: group) }
  let!(:account_in_the_same_company) { create(:order, group: group_in_the_same_company) }
  let!(:account_in_the_different_company) { create(:order, group: group_in_different_company) }

  describe 'order' do
    let!(:query_string) {
      <<-GRAPHQL
        query($id: ID!) {
          orders {
            id
            name
            point
            buyer
            seller
            createdAt
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it 'return an order' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: order.id })
        expect(result.dig('data', 'order')).to eq(
          'id' => order.id.to_s,
          'name' => order.name,
          'price' => order.price
        )
      end
    end


  end
end
