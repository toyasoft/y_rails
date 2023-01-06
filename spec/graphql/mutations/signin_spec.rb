require 'rails_helper'

describe Mutations::Signin do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($object: UserAttributes!) {
        signin(
          input: {
            object: $object
          }
        ){
          user {
            email
          }
          userToken
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
  context 'ユーザーが存在しない場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'パスワードが間違えている場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'メールアドレスが空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'パスワードが空の場合' do
    it 'エラーを返す' do
      
    end
  end


end
