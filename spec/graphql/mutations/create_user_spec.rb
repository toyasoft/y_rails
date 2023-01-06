require 'rails_helper'

describe Mutations::CreateUser do
  let!(:user) { create(:user) }
  let!(:query_string) {
    <<-GRAPHQL
      mutation($object: UserAttributes!) {
        createUser(
          input: {
            object: $object
          }
        ){
          user {
            email
          }
        }
      }
    GRAPHQL
  }

  context '通常時' do
    it 'ユーザーオブジェクトを返す' do
      object = {
        name: "ユーザー1",
        email: "info@toyasoft.com"
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
  context 'メールアドレスが空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'パスワードが空の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'メールアドレスが有効でない場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'メールアドレスが正しくない場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'メールアドレスが256文字以上の場合' do
    it 'エラーを返す' do
      
    end
  end
  context 'メールアドレスが重複している場合' do
    it 'エラーを返す' do
      
    end
  end

end
