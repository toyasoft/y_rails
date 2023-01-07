require 'rails_helper'

describe Types::QueryType do
  let!(:item) { create(:item) }
  let!(:deleted_item) { create(:item, del: 1) }

  describe 'item' do
    let!(:query_string) {
      <<-GRAPHQL
        query($id: ID!) {
          item(id: $id) {
            id
            name
            point
          }
        }
      GRAPHQL
    }

    context '通常時' do
      it '商品オブジェクトを返す' do
        result = WorkspaceSchema.execute(query_string, variables: { id: item.id })
        expect(result.dig('data', 'item')).to eq(
          'id' => item.id.to_s,
          'name' => item.name,
          'point' => item.point
        )
      end
    end
    context '商品IDが空の場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, variables: { id: nil })
        expect(result.dig('data', 'item')).to be_nil
        expect(result.dig('errors', 0, 'message')).to eq "Variable $id of type ID! was provided invalid value"
      end
    end
    context '商品IDが無効の場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, variables: { id: "example" })
        expect(result.dig('data', 'item')).to be_nil
        expect(result.dig('errors', 0, 'message')).to eq "商品IDが無効です"
      end
    end
    context '商品が存在しない場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, variables: { id: 9999 })
        expect(result.dig('data', 'item')).to be_nil
        expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
      end
    end
    context '商品が削除済みの場合' do
      it 'エラーを返す' do
        result = WorkspaceSchema.execute(query_string, variables: { id: deleted_item.id })
        expect(result.dig('data', 'item')).to be_nil
        expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
      end
    end

  end
end
