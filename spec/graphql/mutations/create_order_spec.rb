require 'rails_helper'

describe Mutations::CreateOrder do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($itemId: ID!) {
        creatOrder(
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
        itemId: item_id
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: { object: object })
      expect(result.dig('data', 'createUser', 'item')).not_to be_blank
      expect(User.count).to eq 1
      expect(User.first).to have_attributes(
        name: 'ユーザー1',
        email: "info@toyasoft.com"
      )
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
  context '商品が存在しない場合' do
    it 'エラーを返す' do
      
    end
  end


end
