require 'rails_helper'

describe Mutations::CreateOrder do
  let!(:user) { create(:user) }
  let!(:item) { create(:item) }
  let!(:deleted_item) { create(:item, del: true) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($itemId: ID!) {
        createOrder(
          input: {
            itemId: $itemId
          }
        ){
          order {
            id
            name
            point
            buyer
            seller
            createdAt
          }
          buyer {
            id
            email
            point
          }
          seller {
            id
            email
            point
          }
        }
      }
    GRAPHQL
  }

  context '通常時' do
    it 'オーダーオブジェクトを返す' do
      object = {
        itemId: item.id
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).not_to be_blank
      expect(Order.count).to eq 1
      expect(Order.first).to have_attributes(
        name: item.name,
        point: item.point,
        buyer: user.email,
        seller: item.user.email
      )
    end
  end
  context '未ログインの場合' do
    it 'エラーを返す' do
      object = {
        itemId: item.id
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "認証エラーです"
    end
  end
  context '商品IDが空の場合' do
    it 'エラーを返す' do
      object = {
        itemId: nil
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $itemId of type ID! was provided invalid value"
    end
  end
  context '商品IDが無効の場合' do
    it 'エラーを返す' do
      object = {
        itemId: "example"
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item with"
    end
  end
  context '商品が存在しない場合' do
    it 'エラーを返す' do
      object = {
        itemId: 9999
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item with"
    end
  end
  context '商品が削除済みの場合' do
    it 'エラーを返す' do
      object = {
        itemId: deleted_item.id
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createOrder', 'order')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item with"
    end
  end


end
