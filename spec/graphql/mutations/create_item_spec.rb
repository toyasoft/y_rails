require 'rails_helper'

describe Mutations::CreateItem do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($name: String! $point: Int!) {
        createItem(
          input: {
            name: $name,
            point: $point
            
          }
        ){
          item {
            id
            name
            point
          }
        }
      }
    GRAPHQL
  }

  context '通常時' do
    it '商品オブジェクトを返す' do
      object = {
        name: "商品1",
        point: 1000
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).not_to be_blank
      expect(Item.count).to eq 1
      expect(Item.first).to have_attributes(
        name: '商品1',
        point: 1000
      )
    end
  end
  context '未ログインの場合' do
    it 'エラーを返す' do
      object = {
        name: "商品1",
        point: 1000
      }

      result = WorkspaceSchema.execute(query_string, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "認証エラーです"
    end
  end
  context '商品名が空の場合' do
    it 'エラーを返す' do
      object = {
        name: nil,
        point: 1000
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $name of type String! was provided invalid value"
    end
  end
  context '商品名が256文字以上の場合' do
    it 'エラーを返す' do
      object = {
        name: "あ" * 256,
        point: 1000
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Validation failed: Name is too long"
    end
  end
  context 'ポイントが空の場合' do
    it 'エラーを返す' do
      object = {
        name: "商品1",
        point: nil
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end
  context 'ポイントが数値でない場合' do
    it 'エラーを返す' do
      object = {
        name: "商品1",
        point: "expample"
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end
  context 'ポイントが11桁以上の場合' do
    it 'エラーを返す' do
      object = {
        name: "商品1",
        point: 10000000000
      }

      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object )
      expect(result.dig('data', 'createItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end

end
