require 'rails_helper'

describe Mutations::DeleteItem do
  let(:query_string) {
    <<-GRAPHQL
      mutation($id: ID!) {
        deleteItem(
          input: {
            id: $id
          }
        ){
          deletedItemId
        }
      }
    GRAPHQL
  }

  context '通常時' do
    let(:item) { create(:item, group: group) }

    it 'delete an item' do
      result = WebSchema.execute(query_string, context: { current_user: user }, variables: { id: item.id })
      item.reload

      expect(item.discarded?).to eq true
      expect(Item.kept.ids).not_to include item.id
      expect(result.dig('data', 'deleteItem', 'item', 'id')).to eq item.id.to_s
    end
  end
  context '未ログインの場合' do
    it 'エラーを返す' do
      
    end
  end
  context '商品IDが空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context '商品IDが無効の場合' do
    it 'エラーを返す' do
      
    end
  end
  context '商品が削除済みの場合' do
    it 'エラーを返す' do
      
    end
  end

end
