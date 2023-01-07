require 'rails_helper'

describe Types::QueryType do
  let!(:item) { create(:item) }
  let!(:deleted_item) { create(:item, del: 1) }

  describe 'items' do
    let!(:query_string) {
      <<-GRAPHQL
        query {
          items {
            id
            name
            point
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it '削除フラグの立っていない商品オブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string)
        expect(result.dig('data', 'items')).to contain_exactly(
          {
            'id' => item.id.to_s,
            'name' => item.name,
            'point' => item.point
          }
        )
        expect(result.dig('data', 'items')).not_to contain_exactly(
          {
            'id' => deleted_item.id.to_s,
            'name' => deleted_item.name,
            'point' => deleted_item.point
          }
        )
      end
    end


  end
end
