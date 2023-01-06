require 'rails_helper'

describe Mutations::CreateItem do
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
            name
            price
          }
        }
      }
    GRAPHQL
  }

  context '通常時' do
    it '商品オブジェクトを返す' do
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
  context '未ログインの場合' do
    it 'エラーを返す' do
      
    end
  end
  context '商品名が空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context '商品名が256文字以上の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'ポイントが空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'ポイントが数値でない場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'ポイントが11桁以上の場合' do
    it 'エラーを返す' do
      
    end
  end

end
