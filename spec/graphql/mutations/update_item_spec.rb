require 'rails_helper'

describe Mutations::UpdateItem do
  let!(:user) { create(:user) }
  let!(:item) { create(:item, user_id: user.id) }
  let!(:deleted_item) { create(:item, user_id: user.id, del: true) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($id: ID! $name: String! $point: Int!) {
        updateItem(
          input: {
            id: $id,
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
        id: item.id,
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)
      item.reload

      expect(result.dig('data', 'updateItem', 'item')).not_to be_blank
      expect(result.dig('data', 'updateItem', 'item')).to eq(
        'id' => item.id.to_s,
        'name' => '商品2',
        'point' => 2000
      )
    end
  end
  context '未ログインの場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "認証エラーです"
    end
  end
  context '商品IDが空の場合' do
    it 'エラーを返す' do
      object = {
        id: nil,
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $id of type ID! was provided invalid value"
    end
  end
  context '商品IDが無効の場合' do
    it 'エラーを返す' do
      object = {
        id: "example",
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
    end
  end
  context '商品が存在しない場合' do
    it 'エラーを返す' do
      object = {
        id: 9999,
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
    end
  end
  context '商品が削除済みの場合' do
    it 'エラーを返す' do
      object = {
        id: deleted_item.id,
        name: "商品2",
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Couldn't find Item"
    end
  end
  context '商品名が空の場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: nil,
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $name of type String! was provided invalid value"
    end
  end
  context '商品名が256文字以上の場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: "あ" * 256,
        point: 2000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to include "Validation failed: Name is too long"
    end
  end
  context 'ポイントか空の場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: "商品2",
        point: nil
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end
  context 'ポイントが数値でない場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: "商品2",
        point: "example"
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end
  context 'ポイントが11桁以上の場合' do
    it 'エラーを返す' do
      object = {
        id: item.id,
        name: "商品2",
        point: 10000000000
      }
      result = WorkspaceSchema.execute(query_string, context: { current_user: user }, variables: object)

      expect(result.dig('data', 'updateItem', 'item')).to be_blank
      expect(result.dig('errors', 0, 'message')).to eq "Variable $point of type Int! was provided invalid value"
    end
  end


end
