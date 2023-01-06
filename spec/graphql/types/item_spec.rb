require 'rails_helper'

describe Types::QueryType do
  let!(:group) { create(:group) }
  let!(:group_in_the_same_company) { create(:group, company: group.company) }
  let!(:group_in_different_company) { create(:group) }
  let!(:user) { create(:user, group: group) }
  let!(:item) { create(:item, group: group) }
  let!(:account_in_the_same_group) { create(:item, group: group) }
  let!(:account_in_the_same_company) { create(:item, group: group_in_the_same_company) }
  let!(:account_in_the_different_company) { create(:item, group: group_in_different_company) }

  describe 'item' do
    let!(:query_string) {
      <<-GRAPHQL
        query($id: ID!) {
          item(id: $id) {
            id
            name
            price
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it '商品オブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: item.id })
        expect(result.dig('data', 'item')).to eq(
          'id' => item.id.to_s,
          'name' => item.name,
          'price' => item.price
        )
      end
    end
    context '商品IDが空の場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'item')).to be_nil
      end
    end
    context '商品IDが無効の場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'item')).to be_nil
      end
    end
    context '商品が存在しない場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'item')).to be_nil
      end
    end
    context '商品が削除済みの場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, context: { current_user: user })
        expect(result.dig('data', 'item')).to be_nil
      end
    end

  end
end
