require 'rails_helper'

describe Mutations::DeleteItem do
  let!(:user) { create(:user) }
  let!(:item) { create(:item, user_id: user.id) }
  let!(:deleted_item) { create(:item, user_id: user.id, del: true) }
  let!(:query_string) {
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
    

    it '商品IDを返す' do
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: item.id })
      item.reload

      expect(item.del).to eq true
      expect(Item.where(del: 0)).not_to include item.id
      expect(result.dig('data', 'deleteItem', 'deletedItemId')).to eq item.id.to_s
    end
  end
  context '未ログインの場合' do
    it 'エラーを返す' do
      result = WorkspaceSchema.execute(query_string, variables: { id: item.id })

      expect(result.dig('data', 'createItem', 'deletedItemId')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "認証エラーです"
    end
  end
  context '商品IDが空の場合' do
    it 'エラーを返す' do
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: nil })
      item.reload

      expect(result.dig('data', 'createItem', 'deletedItemId')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $id of type ID! was provided invalid value"
    end
  end
  context '商品IDが無効の場合' do
    it 'エラーを返す' do
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: "example" })
      item.reload

      expect(result.dig('data', 'createItem', 'deletedItemId')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item with"
    end
  end
  context '商品が削除済みの場合' do
    it 'エラーを返す' do
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { id: deleted_item.id })
      item.reload

      expect(result.dig('data', 'createItem', 'deletedItemId')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
    end
  end

end
