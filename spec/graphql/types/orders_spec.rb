require 'rails_helper'

describe Types::QueryType do
  let!(:buyer) { create(:user) }
  let!(:seller) { create(:user) }
  let!(:item) { create(:item)}
  let!(:order) { create(:order, name: item.name, point: item.point, buyer: buyer.email, seller: seller.email, user_id: buyer.id, item_id: item.id) }

  describe 'orders' do
    let!(:query_string) {
      <<-GRAPHQL
        query {
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
      it '注文オブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string)
        expect(result.dig('data', 'orders')).to contain_exactly(
          {
            'id' => order.id.to_s,
            'name' => item.name,
            'point' => item.point,
            'buyer' => buyer.email,
            'seller' => seller.email,
            'createdAt' => item.created_at.to_s.to_datetime
          }
        )
      end
    end


  end
end
